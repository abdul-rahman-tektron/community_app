// payment_notifier.dart

import 'dart:io';

import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/customer/job/create_job_booking_request.dart';
import 'package:Xception/core/model/customer/job/create_job_booking_response.dart';
import 'package:Xception/core/model/customer/job/create_payment_intent_request.dart';
import 'package:Xception/core/model/customer/job/create_payment_intent_response.dart';
import 'package:Xception/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:Xception/core/model/customer/payment/create_payment/create_payment_request.dart';
import 'package:Xception/core/model/customer/payment/create_payment/create_payment_response.dart';
import 'package:Xception/core/model/customer/payment/payment_detail_request.dart';
import 'package:Xception/core/model/customer/payment/payment_detail_response.dart';
import 'package:Xception/core/model/customer/payment/payment_status/payment_status_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_dashboard_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:Xception/res/images.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/helpers/payment_service.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:Xception/utils/widgets/custom_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentNotifier extends BaseChangeNotifier {
  bool saveCard = false;
  PaymentMethod? selectedPaymentMethod;


  final PaymentArgs args;

  bool get isPartialPayment => args.isPartialPayment ?? false;
  int get jobId => args.jobId;
  int get vendorId => args.vendorId;

  PaymentDetailResponse paymentDetail = PaymentDetailResponse();

  // Stripe card field state
  CardFieldInputDetails? _cardFieldDetails;

  bool get isCardComplete => _cardFieldDetails?.complete ?? false;

  // Text controllers
  final promoCodeController = TextEditingController();
  final cardNumberController = TextEditingController(); // no longer used in UI
  final expiryDateController = TextEditingController(); // no longer used in UI
  final cvvController = TextEditingController(); // no longer used in UI
  final cardHolderNameController = TextEditingController();

  bool isTermsExpanded = false;

  List<PaymentMethod> get paymentMethods {
    final walletsLabel = Platform.isIOS ? "Apple Pay" : "Google Pay";
    final walletsIcon  = Platform.isIOS ? AppImages.applePay : AppImages.googlePay;

    return [
      PaymentMethod(id: 2, name: "Credit / Debit Card", isCard: true),

      // show only the right wallet per OS
      PaymentMethod(
        id: 1,
        name: walletsLabel,
        iconUrl: walletsIcon,
        isCard: false,
      ),
    ];
  }

  PaymentNotifier({required this.args}) {
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
    final vatTotal = items.fold<num>(0, (s, it) => s + (_linePreVat(it) * 0.05 ?? 0));
    return (subTotal + vatTotal).toDouble();
  }

  double get paidAmountFromApi {
    return (paymentDetail.totals?.paidAmount ?? 0).toDouble();
  }

  double calculatePayableAmount() {
    final frontEndGrandTotal = calculateGrandTotal();
    final paidAmount = paidAmountFromApi;

    // Partial payment flow -> always pay 50% of frontend total
    if (isPartialPayment) {
      return double.parse((frontEndGrandTotal / 2).toStringAsFixed(2));
    }

    // Full/remaining payment flow
    final remaining = frontEndGrandTotal - paidAmount;

    // safety: never go below zero
    if (remaining <= 0) {
      return 0.0;
    }

    return double.parse(remaining.toStringAsFixed(2));
  }

  int calculatePayableAmountInFils() {
    return (calculatePayableAmount() * 100).round();
  }

  double calculateFrontEndGrandTotal() {
    return calculateGrandTotal();
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
        if(!(isPartialPayment)) {
          Navigator.pushNamed(context, AppRoutes.feedback, arguments: jobId);
        }
      }
    } catch (e) {
      ToastHelper.showError('Error updating status: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiPaymentStatus(BuildContext context, String paymentIntentId,
      {bool? isPartialPayment}) async {
    try {
        final result = await CustomerJobsRepository.instance.apiPaymentStatus(paymentIntentId);
        await _handleCreatedPaymentSuccess(result, context);
    } catch (e) {
      print("apiCreatePayment error: $e");
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedPaymentSuccess(dynamic result, BuildContext context) async {
    if (result is PaymentStatusResponse) {
      if(result.transactionStatus == "succeeded") {
        await apiUpdateJobStatus(context, AppStatus.paymentCompleted.id);
        if (isPartialPayment) {
          bookingConfirmationPopup(
            context,
            onConfirm: (String isoDate, String? note) async {
              await apiJobBooking(
                context,
                jobId: args.metaData?.jobId ?? 0,
                quotationRequestId: args.metaData?.quotationRequestId ?? 0,
                quotationResponseId: args.metaData?.quotationResponseId ?? 0,
                vendorId: args.metaData?.vendorId ?? 0,
                remarks: (note != null && note.isNotEmpty)
                    ? note
                    : "Accepted by customer",
                dateOfVisit: isoDate,
              );
            },
          );
        }
      } else {
        ToastHelper.showError("Payment Failed.");
      }
    } else {
      ToastHelper.showError("Something went wrong while recording payment.");
    }
  }

  Future<void> apiJobBooking(
      BuildContext context, {
        required int jobId,
        required int quotationRequestId,
        required int quotationResponseId,
        required int vendorId,
        String? remarks,
        required String dateOfVisit, // yyyy-MM-dd
      }) async {
    try {
      final request = CreateJobBookingRequest(
        jobId: jobId,
        quotationRequestId: quotationRequestId,
        quotationResponseId: quotationResponseId,
        vendorId: vendorId,
        remarks: remarks ?? "Accepted by customer",
        createdBy: userData?.name ?? "Customer",
        dateOfVisit: dateOfVisit,

        // ⚠️ If your DB requires VisitorEmail (as the error showed), include it here:
        // visitorEmail: userData?.email,  // <- add this field in the request model if present
      );

      final result = await CustomerDashboardRepository.instance.apiCreateJobBookingRequest(request);
      print("result");
      print(result);

      await _handleCreatedJobSuccess(result, jobId, context, dateOfVisit);
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedJobSuccess(Object? result, int? jobId, BuildContext context, String dateOfVisit) async {
    // Case 1: Booking returned email preview (like site-visit)
    if (result is JobBookingResponse && result.emailPreview != null) {
      final emailData = result.emailPreview!;
      final email = Email(
        body: emailData.body ?? "",
        subject: emailData.subject ?? "Job  Booking Confirmation",
        recipients: emailData.to ?? const [],
        cc: emailData.cc ?? const [],
        isHTML: true,
      );

      try {
        await FlutterEmailSender.send(email);
        ToastHelper.showSuccess(result.message ?? "Booking created and email prepared.");
      } catch (e) {
        print("Error launching email client: $e");
        ToastHelper.showError("No email client available on this device.");
      }

      // Update status if you have a status for booking confirmation
      await apiUpdateJobStatus(context, AppStatus.quotationAccepted.id);

      // Navigate to success screen
      Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: {
        'bookingId': jobId?.toString(),
        'email': userData?.email,
        'bookingDate': dateOfVisit,
      });
      return;
    }

    // Case 2: Generic common response
    if (result is CommonResponse) {
      if (result.success == true) {
        ToastHelper.showSuccess(result.message ?? "Booking created successfully.");
        await apiUpdateJobStatus(context, AppStatus.quotationAccepted.id);
        Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: jobId?.toString());
      } else {
        ToastHelper.showError(result.message ?? "Failed to create booking.");
      }
      return;
    }

    // Fallback
    ToastHelper.showError("Unexpected response from server.");
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

      // 1) Calculate amount11/02/2026
      final amountAED = overrideGrandTotal ?? calculatePayableAmount();
      final amountInFils = (amountAED * 100).round();

      // 2) Ask backend to create PaymentIntent and return clientSecret
      final clientSecretResponse = await CustomerJobsRepository.instance.apiCreatePaymentIntent(
        CreatePaymentIntentRequest(
          amount: amountInFils,
          totalAmount: amountInFils,
          remarks: "Test",
          currency: "AED",
          paymentIdentity: selectedPaymentMethod?.id ?? 0,
          quotationId: jobId,
          amountFrom: userData?.customerId ?? 0,
          amountTo: vendorId,
          jobId: jobId,
          invoiceNumber: "",
          paymentTowards: "",
          transactionStatus: "",
          mode: selectedPaymentMethod?.name ?? "Payment",
          type: selectedPaymentMethod?.name ?? "Payment",
          transactionDate: DateTime.now(),
          referenceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
          referenceType: selectedPaymentMethod?.name ?? "Card",
        )
      );

      String? clientSecret;
      String? paymentIntentId;

      if (clientSecretResponse is CreatePaymentIntentResponse) {
        clientSecret = clientSecretResponse.clientSecret;
        paymentIntentId = clientSecretResponse.stripePaymentIntentId;
      }

      if (clientSecretResponse == null) {
        ToastHelper.showError("Unable to start payment. Please try again.");
        return;
      }

      // 3) Init PaymentSheet (card only)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "Xception",
          style: ThemeMode.system,
        ),
      );

      // 4) Present PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      // // 5) On success → record payment in your backend
      await verifyPaymentAndProceed(context, paymentIntentId ?? "");
    } on StripeException catch (e, st) {
      print("Payment cancelled or failed message: ${e.error.message}");
      print("Payment cancelled or failed code: ${e.error.code}");
      print("Payment cancelled or failed decline code: ${e.error.declineCode}");
      print("Payment cancelled or failed localized messaage: ${e.error.localizedMessage}");
      print("Payment cancelled or failed type: ${e.error.type}");
      print("Payment cancelled or failed stripe error code: ${e.error.stripeErrorCode}");
      print("Payment cancelled or failed st: ${st}");
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
          testEnv: false,
        ),
      );

      if (!isSupported) {
        ToastHelper.showError("Google Pay is not supported on this device.");
        return;
      }

      isLoading = true;
      notifyListeners();

      // 1) Calculate amount
      final amountAED = overrideGrandTotal ?? calculatePayableAmount();
      final amountInFils = (amountAED * 100).round();

      // 2) Create PaymentIntent on backend and get clientSecret
      final clientSecretResponse = await CustomerJobsRepository.instance.apiCreatePaymentIntent(
          CreatePaymentIntentRequest(
            amount: amountInFils,
            totalAmount: amountInFils,
            remarks: "Test",
            currency: "AED",
            paymentIdentity: selectedPaymentMethod?.id ?? 0,
            quotationId: jobId,
            amountFrom: userData?.customerId ?? 0,
            amountTo: vendorId,
            jobId: jobId,
            invoiceNumber: "",
            paymentTowards: "",
            transactionStatus: "",
            mode: selectedPaymentMethod?.name ?? "Payment",
            type: selectedPaymentMethod?.name ?? "Payment",
            transactionDate: DateTime.now(),
            referenceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
            referenceType: selectedPaymentMethod?.name ?? "Card",
          )
      );

      String? clientSecret;
      String? paymentIntentId;

      if (clientSecretResponse is CreatePaymentIntentResponse) {
        clientSecret = clientSecretResponse.clientSecret;
        paymentIntentId = clientSecretResponse.stripePaymentIntentId;
      }

      if (clientSecretResponse == null) {
        ToastHelper.showError("Unable to start payment. Please try again.");
        return;
      }

      // 3) Launch native Google Pay sheet and confirm the PaymentIntent
      await Stripe.instance.confirmPlatformPayPaymentIntent(
        clientSecret: clientSecret ?? "",
        confirmParams: PlatformPayConfirmParams.googlePay(
          googlePay: GooglePayParams(
            testEnv: false, // true in test, false in production
            merchantName: 'Xception', // shown in Google Pay sheet
            merchantCountryCode: 'AE',
            currencyCode: 'AED',
          ),
        ),
      );

      // 4) If we reach here without exception → success
      await verifyPaymentAndProceed(context, paymentIntentId ?? "");
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

  Future<void> _payWithApplePayPlatform(
      BuildContext context, {
        double? overrideGrandTotal,
      }) async {
    try {
      if (!Platform.isIOS) {
        ToastHelper.showError("Apple Pay is only available on iOS.");
        return;
      }

      isLoading = true;
      notifyListeners();

      // 1) Calculate amount (AED)
      final amountAED = overrideGrandTotal ?? calculatePayableAmount();
      final amountInFils = (amountAED * 100).round();

      // 2) ✅ Use SAME backend endpoint as Card/GooglePay (important)
      final clientSecretResponse =
      await CustomerJobsRepository.instance.apiCreatePaymentIntent(
        CreatePaymentIntentRequest(
          amount: amountInFils,
          totalAmount: amountInFils,
          remarks: "Apple Pay",
          currency: "aed",
          paymentIdentity: selectedPaymentMethod?.id ?? 0,
          quotationId: jobId,
          amountFrom: userData?.customerId ?? 0,
          amountTo: vendorId,
          jobId: jobId,
          invoiceNumber: "",
          paymentTowards: "",
          transactionStatus: "",
          mode: selectedPaymentMethod?.name ?? "Apple Pay",
          type: selectedPaymentMethod?.name ?? "Apple Pay",
          transactionDate: DateTime.now(),
          referenceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
          referenceType: "ApplePay",
        ),
      );

      String? clientSecret;
      String? paymentIntentId;

      if (clientSecretResponse is CreatePaymentIntentResponse) {
        clientSecret = clientSecretResponse.clientSecret;
        paymentIntentId = clientSecretResponse.stripePaymentIntentId;
      }

      if (clientSecret == null || clientSecret.isEmpty) {
        ToastHelper.showError("Unable to start Apple Pay. Please try again.");
        return;
      }

      // 3) ✅ Confirm Apple Pay
      await Stripe.instance.confirmPlatformPayPaymentIntent(
        clientSecret: clientSecret,
        confirmParams: PlatformPayConfirmParams.applePay(
          applePay: ApplePayParams(
            merchantCountryCode: 'AE',
            currencyCode: 'AED',
            cartItems: [
              ApplePayCartSummaryItem.immediate(
                label: 'Service payment',
                amount: amountAED.toStringAsFixed(2),
              ),
            ],
          ),
        ),
      );

      // 4) ✅ Verify from backend & update job status
      await verifyPaymentAndProceed(context, paymentIntentId ?? "");
    } on StripeException catch (e, st) {
      print("Apple Pay failed: ${e.error.localizedMessage}");
      print("Apple Pay code: ${e.error.code}");
      print("Apple Pay type: ${e.error.type}");
      print("Apple Pay stack: $st");
      ToastHelper.showError("Apple Pay failed: ${e.error.localizedMessage}");
    } catch (e) {
      print("Apple Pay PlatformPay Failed: $e");
      ToastHelper.showError("Payment Failed: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyPaymentAndProceed(BuildContext context, String paymentIntentId) async {
    try {
      // 1) ✅ update status first (ignore response body)
      final updated = await CustomerJobsRepository.instance.apiPaymentUpdateStatus(paymentIntentId);

      if (!updated) {
        ToastHelper.showError("Payment update failed.");
        return;
      }

      // 2) ✅ if update API returned 200, then fetch payment status
      final result = await CustomerJobsRepository.instance.apiPaymentStatus(paymentIntentId);

      // 3) continue your existing flow
      await _handleCreatedPaymentSuccess(result, context);
    } catch (e) {
      print("verifyPaymentAndProceed error: $e");
      ToastHelper.showError("An error occurred. Please try again.");
    } finally {
      notifyListeners();
    }
  }
}

class PaymentMethod {
  final int id;
  final String name;
  final String? iconUrl;
  final bool isCard;

  PaymentMethod({required this.id, required this.name, this.iconUrl, required this.isCard});
}


class PaymentMetaData {
  final int? jobId;
  final int? quotationRequestId;
  final int? quotationResponseId;
  final int? vendorId;

  const PaymentMetaData({
    this.jobId,
    this.quotationRequestId,
    this.quotationResponseId,
    this.vendorId,
  });
}

class PaymentArgs {
  final int jobId;
  final int vendorId;
  final bool? isPartialPayment;
  final PaymentMetaData? metaData;

  const PaymentArgs({
    required this.jobId,
    required this.vendorId,
    this.isPartialPayment,
    this.metaData,
  });
}