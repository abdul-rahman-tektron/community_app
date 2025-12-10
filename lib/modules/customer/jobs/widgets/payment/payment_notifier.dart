// payment_notifier.dart

import 'dart:io';

import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:Xception/core/model/customer/payment/create_payment/create_payment_request.dart';
import 'package:Xception/core/model/customer/payment/create_payment/create_payment_response.dart';
import 'package:Xception/core/model/customer/payment/payment_detail_request.dart';
import 'package:Xception/core/model/customer/payment/payment_detail_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/helpers/payment_service.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentNotifier extends BaseChangeNotifier {
  bool saveCard = false;
  PaymentMethod? selectedPaymentMethod;

  int? jobId;
  int? vendorId;

  PaymentDetailResponse paymentDetail = PaymentDetailResponse();

  // Stripe card field state
  CardFieldInputDetails? _cardFieldDetails;
  bool get isCardComplete => _cardFieldDetails?.complete ?? false;

  // Text controllers
  final promoCodeController = TextEditingController();
  final cardNumberController = TextEditingController(); // no longer used in UI
  final expiryDateController = TextEditingController(); // no longer used in UI
  final cvvController = TextEditingController();        // no longer used in UI
  final cardHolderNameController = TextEditingController();

  bool isTermsExpanded = false;

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 2,
      name: "Credit / Debit Card",
      isCard: true,
    ),
    PaymentMethod(
      id: 1,
      name: "Apple Pay / Google Pay",
      iconUrls: [AppImages.applePay, AppImages.googlePay],
      isCard: false,
    ),
  ];

  PaymentNotifier(this.jobId, this.vendorId) {
    initializeData();
  }

  Future<void> initializeData() async {
    await loadUserData();
    await apiPaymentDetails();
  }

  // ========== DATA / UI HELPERS ==========

  Future<void> apiPaymentDetails() async {
    try {
      final result = await CustomerJobsRepository.instance.apiPaymentDetail(
        PaymentDetailRequest(vendorId: vendorId, jobId: jobId),
      );

      if (result is PaymentDetailResponse) {
        paymentDetail = result;
      } else if (result is Map<String, dynamic>) {
        paymentDetail = PaymentDetailResponse.fromJson(result);
      } else if (result is String) {
        paymentDetail = paymentDetailResponseFromJson(result);
      } else {
        final data = (result as dynamic)?.data;
        if (data is Map<String, dynamic>) {
          paymentDetail = PaymentDetailResponse.fromJson({'data': data});
        } else {
          throw Exception('Unsupported payment detail response type');
        }
      }
    } catch (e) {
      print("apiPaymentDetails error: $e");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleTermsExpanded() {
    isTermsExpanded = !isTermsExpanded;
    notifyListeners();
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod = method;
    notifyListeners();
  }

  bool isSelected(PaymentMethod method) {
    return selectedPaymentMethod?.id == method.id;
  }

  void toggleSaveCard() {
    saveCard = !saveCard;
    notifyListeners();
  }

  void onCardChanged(CardFieldInputDetails? details) {
    _cardFieldDetails = details;
    notifyListeners();
  }

  // ========== AMOUNT CALCULATION ==========

  num _linePreVat(LineItem it) {
    final q = it.quantity ?? 0;
    if (q == 0) return it.rate ?? 0;
    if (it.amount != null) return it.amount!;
    return (it.rate ?? 0) * q;
  }

  double calculateGrandTotal() {
    final items = paymentDetail.lineItems ?? const <LineItem>[];
    final subTotal = items.fold<num>(0, (s, it) => s + _linePreVat(it));
    final vatTotal = items.fold<num>(0, (s, it) => s + (it.vat ?? 0));
    return (subTotal + vatTotal).toDouble();
  }

  // ========== BACKEND JOB STATUS / PAYMENT RECORD ==========

  Future<void> apiUpdateJobStatus(BuildContext context, int? statusId) async {
    if (statusId == null) return;
    try {
      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(
          jobId: jobId,
          statusId: statusId,
          createdBy: userData?.name ?? "",
          vendorId: userData?.customerId ?? 0,
        ),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        Navigator.pushNamed(context, AppRoutes.feedback, arguments: jobId);
      }
    } catch (e) {
      ToastHelper.showError('Error updating status: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiCreatePayment(BuildContext context, {required double amountAED}) async {
    try {
      final request = CreatePaymentRequest(
        paymentIdentity: selectedPaymentMethod?.id ?? 0,
        quotationId: jobId,
        amountFrom: userData?.customerId ?? 0,
        amountTo: vendorId,
        jobId: jobId,
        amount: amountAED,
        mode: selectedPaymentMethod?.name ?? "Payment",
        type: selectedPaymentMethod?.name ?? "Payment",
        transactionDate: DateTime.now(),
        referenceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
        referenceType: selectedPaymentMethod?.name ?? "Card",
      );

      final result = await CustomerJobsRepository.instance.apiCreatePayment(request);
      await _handleCreatedPaymentSuccess(result, context);
    } catch (e) {
      print("apiCreatePayment error: $e");
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedPaymentSuccess(dynamic result, BuildContext context) async {
    if (result is CreatePaymentResponse) {
      ToastHelper.showSuccess(result.message ?? "Payment recorded successfully.");
      await apiUpdateJobStatus(context, AppStatus.paymentCompleted.id);
    } else {
      ToastHelper.showError("Something went wrong while recording payment.");
    }
  }

  // ========== STRIPE – PUBLIC ENTRY POINT ==========

  Future<void> makePayment(BuildContext context, {double? overrideGrandTotal}) async {
    if (selectedPaymentMethod == null) {
      ToastHelper.showError("Please select a payment method.");
      return;
    }

    // 1) Normal card (Stripe card + PaymentSheet)
    if (selectedPaymentMethod!.id == 2 && selectedPaymentMethod!.isCard) {
      await _payWithCard(context, overrideGrandTotal: overrideGrandTotal);
      return;
    }

    // 2) Google Pay (Android only) via Platform Pay
    if (selectedPaymentMethod!.id == 1 && Platform.isAndroid) {
      await _payWithGooglePayPlatform(context, overrideGrandTotal: overrideGrandTotal);
      return;
    }

    // 3) Apple Pay (iOS only) via Platform Pay
    if (selectedPaymentMethod!.id == 1 && Platform.isIOS) {
      await _payWithApplePayPlatform(context, overrideGrandTotal: overrideGrandTotal);
      return;
    }

    ToastHelper.showError("Unsupported payment method.");
  }

  // ========== STRIPE – CARD ONLY (no wallets yet) ==========

  Future<void> _payWithCard(BuildContext context, {double? overrideGrandTotal}) async {

    try {
      isLoading = true;
      notifyListeners();

      // 1) Calculate amount
      final amountAED = overrideGrandTotal ?? calculateGrandTotal();
      final amountInFils = (amountAED * 100).round(); // AED -> fils

      // 2) Ask backend to create PaymentIntent and return clientSecret
      // final clientSecret = await PaymentService.createPaymentIntent(
      //   amountInMinorUnits: amountInFils,
      //   currency: 'aed',
      //   description: 'Payment for job #$jobId',
      // );

      final clientSecret = "pi_3Sbzcl5Us833x6am1GUyPTDX_secret_u1cxDNXIrAEvBbwXQ3Dn1ajzv";

      if (clientSecret == null) {
        ToastHelper.showError("Unable to start payment. Please try again.");
        return;
      }

      // 3) Init PaymentSheet (card only)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Xception",
          // No GooglePay/ApplePay here for now → card only
          style: ThemeMode.system,
        ),
      );

      // 4) Present PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      // 5) On success → record payment in your backend
      await apiCreatePayment(context, amountAED: amountAED);

      ToastHelper.showSuccess("Payment successful.");
    } on StripeException catch (e) {
      ToastHelper.showError("Payment cancelled or failed: ${e.error.localizedMessage}");
    } catch (e) {
      print("Payment Failed: $e");
      ToastHelper.showError('Payment Failed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _payWithGooglePayPlatform(BuildContext context, {double? overrideGrandTotal}) async {
    try {
      // 0) Check if Google Pay is supported on this device
      final isSupported = await Stripe.instance.isPlatformPaySupported(
        googlePay: const IsGooglePaySupportedParams(
          testEnv: true, // true for test mode
        ),
      );

      if (!isSupported) {
        ToastHelper.showError("Google Pay is not supported on this device.");
        return;
      }

      isLoading = true;
      notifyListeners();

      // 1) Calculate amount
      final amountAED = overrideGrandTotal ?? calculateGrandTotal();
      final amountInFils = (amountAED * 100).round(); // AED -> fils

      // 2) Create PaymentIntent on backend and get clientSecret
      // final clientSecret = await PaymentService.createPaymentIntent(
      //   amountInMinorUnits: amountInFils,
      //   currency: 'aed',
      //   description: 'Payment for job #$jobId (Google Pay)',
      // );

      // For quick test only, you *could* temporarily hardcode:
      const clientSecret = "pi_3Sbzcl5Us833x6am1GUyPTDX_secret_u1cxDNXIrAEvBbwXQ3Dn1ajzv";
      // but real flow should use the backend call above.

      if (clientSecret == null) {
        ToastHelper.showError("Unable to start Google Pay. Please try again.");
        return;
      }

      // 3) Launch native Google Pay sheet and confirm the PaymentIntent
      await Stripe.instance.confirmPlatformPayPaymentIntent(
        clientSecret: clientSecret,
        confirmParams: PlatformPayConfirmParams.googlePay(
          googlePay: GooglePayParams(
            testEnv: true,            // true in test, false in production
            merchantName: 'Xception', // shown in Google Pay sheet
            merchantCountryCode: 'AE',
            currencyCode: 'AED',
          ),
        ),
      );

      // 4) If we reach here without exception → success
      await apiCreatePayment(context, amountAED: amountAED);
      ToastHelper.showSuccess("Payment successful via Google Pay.");
    } on StripeException catch (e) {
      ToastHelper.showError("Google Pay cancelled or failed: ${e.error.localizedMessage}");
    } catch (e) {
      print("Google Pay PlatformPay Failed: $e");
      ToastHelper.showError('Payment Failed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _payWithApplePayPlatform(BuildContext context, {double? overrideGrandTotal}) async {
    try {
      // 0) Check if Apple Pay is supported on this device
      final isSupported = await Stripe.instance.isPlatformPaySupported(
        // applePay: const IsApplePaySupportedParams(),
      );

      if (!isSupported) {
        ToastHelper.showError("Apple Pay is not available on this device.");
        return;
      }

      isLoading = true;
      notifyListeners();

      // 1) Calculate amount (AED)
      final amountAED = overrideGrandTotal ?? calculateGrandTotal();
      final amountInFils = (amountAED * 100).round(); // smallest unit

      // 2) Create PaymentIntent on your backend and get clientSecret
      final clientSecret = await PaymentService.createPaymentIntent(
        amountInMinorUnits: amountInFils,
        currency: 'aed',
        description: 'Payment for job #$jobId (Apple Pay)',
      );

      // For quick temporary testing, you *could* hardcode:
      // const clientSecret = "pi_..._secret_...";
      // but production should always call backend as above.

      if (clientSecret == null) {
        ToastHelper.showError("Unable to start Apple Pay. Please try again.");
        return;
      }

      // 3) Launch native Apple Pay sheet and confirm the PaymentIntent
      await Stripe.instance.confirmPlatformPayPaymentIntent(
        clientSecret: clientSecret,
        confirmParams: PlatformPayConfirmParams.applePay(
          applePay: ApplePayParams(
            merchantCountryCode: 'AE',
            currencyCode: 'AED',
            // This appears in the Apple Pay sheet
            // merchantName: 'Xception',
            // Single total line item – Stripe does the math on the backend
            cartItems: [
              ApplePayCartSummaryItem.immediate(
                label: 'Service payment',      // what user sees
                amount: amountAED.toStringAsFixed(2),
              ),
            ],
          ),
        ),
      );

      // 4) If no exception → success, log payment in your backend
      await apiCreatePayment(context, amountAED: amountAED);
      ToastHelper.showSuccess("Payment successful via Apple Pay.");
    } on StripeException catch (e) {
      ToastHelper.showError("Apple Pay cancelled or failed: ${e.error.localizedMessage}");
    } catch (e) {
      print("Apple Pay PlatformPay Failed: $e");
      ToastHelper.showError('Payment Failed: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class PaymentMethod {
  final int id;
  final String name;
  final List<String>? iconUrls;
  final bool isCard;

  PaymentMethod({
    required this.id,
    required this.name,
    this.iconUrls,
    required this.isCard,
  });
}