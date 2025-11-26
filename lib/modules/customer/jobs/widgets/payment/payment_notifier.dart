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
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:flutter/material.dart';

class PaymentNotifier extends BaseChangeNotifier {
  bool saveCard = false;

  PaymentMethod? selectedPaymentMethod;

  int? jobId;
  int? vendorId;

  PaymentDetailResponse paymentDetail = PaymentDetailResponse();

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: 1,
      name: "Apple Pay / Google Pay",
      iconUrls: [AppImages.applePay, AppImages.googlePay],
      isCard: false,
    ),
    // PaymentMethod(
    //   id: 5,
    //   name: "Cash",
    //   isCard: false,
    // ),
    PaymentMethod(
      id: 2,
      name: "Credit / Debit Card",
      isCard: true,
    ),
    // PaymentMethod(
    //   id: 3,
    //   name: "Tabby",
    //   iconUrls: [AppImages.tabby],
    //   isCard: false,
    // ),
    // PaymentMethod(
    //   id: 4,
    //   name: "Tamara",
    //   iconUrls: [AppImages.tamara],
    //   isCard: false,
    // ),
  ];

  PaymentNotifier(this.jobId, this.vendorId) {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await apiPaymentDetails();
  }

  // PaymentNotifier.apiPaymentDetails()
  Future<void> apiPaymentDetails() async {
    try {
      final result = await CustomerJobsRepository.instance.apiPaymentDetail(
        PaymentDetailRequest(vendorId: vendorId, jobId: jobId),
      );

      // result could be a raw Map, or already a PaymentDetailResponse
      if (result is PaymentDetailResponse) {
        paymentDetail = result;
      } else if (result is Map<String, dynamic>) {
        paymentDetail = PaymentDetailResponse.fromJson(result);
      } else if (result is String) {
        paymentDetail = paymentDetailResponseFromJson(result);
      } else {
        // Try to access response.data if repository returns a network wrapper
        final data = (result as dynamic)?.data;
        if (data is Map<String, dynamic>) {
          paymentDetail = PaymentDetailResponse.fromJson({'data': data});
        } else {
          throw Exception('Unsupported payment detail response type');
        }
      }
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final promoCodeController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderNameController = TextEditingController();

  bool isTermsExpanded = false;

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

  Future<void> apiUpdateJobStatus(BuildContext context, int? statusId) async {
    if (statusId == null) return;
    try {
      notifyListeners();
      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId, createdBy: userData?.name ?? "", vendorId: userData?.customerId ?? 0),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        // ToastHelper.showSuccess("Status updated to: ${AppStatus.fromId(statusId ?? 0)?.name ?? ""}");
        Navigator.pushNamed(context, AppRoutes.feedback, arguments: jobId);
      }
    } catch (e) {
      ToastHelper.showError('Error updating status: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> apiCreatePayment(BuildContext context, {double? overrideGrandTotal}) async {
    try {
      // If the API total looks off, use local computed grand total
      final computedItems = paymentDetail.lineItems ?? const <LineItem>[];
      num _linePreVatLocal(LineItem it) {
        final q = it.quantity ?? 0;
        if (q == 0) return it.rate ?? 0;
        if (it.amount != null) return it.amount!;
        return (it.rate ?? 0) * q;
      }
      final subTotal = computedItems.fold<num>(0, (s, it) => s + _linePreVatLocal(it));
      final vatTotal = computedItems.fold<num>(0, (s, it) => s + (it.vat ?? 0));
      final localGrand = (subTotal + vatTotal).toDouble();

      final request = CreatePaymentRequest(
        paymentIdentity: selectedPaymentMethod?.id ?? 0,
        quotationId: jobId,
        amountFrom: userData?.customerId ?? 0,
        amountTo: vendorId,
        jobId: jobId,
        amount: overrideGrandTotal ?? // prefer UI’s computed if provided
            (paymentDetail.totals?.grandTotal)?.toDouble() ??
            localGrand, // fallback to local computation
        mode: selectedPaymentMethod?.name ?? "Payment",
        type: selectedPaymentMethod?.name ?? "Payment",
        transactionDate: DateTime.now(),
        referenceNumber: DateTime.now().millisecondsSinceEpoch.toString(),
        referenceType: selectedPaymentMethod?.name ?? "Cash",
      );

      final result = await CustomerJobsRepository.instance.apiCreatePayment(request);
      await _handleCreatedPaymentSuccess(result, context);
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedPaymentSuccess(dynamic result, BuildContext context) async {

    if(result is CreatePaymentResponse) {
      ToastHelper.showSuccess(result.message ?? "Success");
      await apiUpdateJobStatus(context, AppStatus.paymentCompleted.id);
    } else {
      ToastHelper.showError("Something Went Wrong");
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
