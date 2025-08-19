import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/create_job_quotation_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class AddQuotationNotifier extends BaseChangeNotifier {
  List<QuotationItem> quotationItems = [];

  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();

  int? jobId;
  int? serviceId;
  int? quotationId;

  final TextEditingController notesController = TextEditingController();

  double get subTotal =>
      quotationItems.fold(0, (sum, item) => sum + item.lineTotal);

  double get vat => subTotal * 0.05;

  double get grandTotal => subTotal + vat;

  AddQuotationNotifier() {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    // Add default empty items for both types
    quotationItems.add(QuotationItem.empty(QuotationItemType.material));
    quotationItems.add(QuotationItem.empty(QuotationItemType.service));
    await apiJobInfoDetail();
    notifyListeners();
  }


  Future<void> apiJobInfoDetail() async {
    try {
      final result = await VendorDashboardRepository.instance.apiJobInfoDetail(jobId?.toString() ?? "0");

      if (result is JobInfoDetailResponse) {
        jobDetail = result;
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiDashboard");
      }
    } catch (e) {
      debugPrint("Error in apiDashboard: $e");
    }
  }

  Future<void> apiUpdateJobStatus(BuildContext context, int? statusId,
      {bool? isReject = false}) async {
    if (statusId == null) return;
    try {
      notifyListeners();

      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId, notes: "Testing"),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        if(isReject ?? false) ToastHelper.showSuccess("Quotation Rejected successfully!");
        Navigator.pop(context);
      }

    } catch (e, stackTrace) {
      print("❌ Error updating job status: $e");
      print("Stack: $stackTrace");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      notifyListeners();
    }
  }

  Future<void> submitQuotation(BuildContext context) async {
    try {
      // Build API request object
      final request = VendorCreateJobQuotationRequest(
        jobId: jobId ?? 0,
        serviceId: serviceId ?? 0,
        vendorId: userData?.customerId ?? 0,
        quotationRequestId: quotationId,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        quotationDetails: notesController.text,
        quotationAmount: grandTotal.toInt(),
        createdBy: userData?.name ?? "", // Can be dynamic
        status: "Submitted",
        jobQuotationResponseItems: quotationItems.map((item) {
          return JobQuotationResponseItem(
            product: item.productController.text,
            quantity: int.tryParse(item.qtyController.text) ?? 0,
            price: int.tryParse(item.unitPriceController.text) ?? 0,
            totalAmount: (item.lineTotal).toInt(),
          );
        }).toList(),
      );

      // Call API
      final response = await VendorQuotationRepository.instance.apiVendorCreateJobQuotationRequest(request);

      if(response is CommonResponse && response.success == true) {
        ToastHelper.showSuccess("Quotation submitted successfully!");
        await apiUpdateJobStatus(context, AppStatus.quotationSubmitted.id);
      }

    } catch (e) {
      ToastHelper.showError("Failed to submit quotation. Please try again.");
    }
  }

  void addItem({QuotationItemType type = QuotationItemType.material}) {
    quotationItems.add(QuotationItem.empty(type));
    notifyListeners();
  }

  void removeItem(int index) {
    final itemToRemove = quotationItems[index];
    final sameTypeCount = quotationItems.where((item) => item.type == itemToRemove.type).length;

    if (sameTypeCount > 1) {
      itemToRemove.dispose();
      quotationItems.removeAt(index);
      notifyListeners();
    } else {
      ToastHelper.showError("At least one ${itemToRemove.type.name} item is required.");
    }
  }

  @override
  void dispose() {
    for (var item in quotationItems) {
      item.dispose();
    }
    notesController.dispose();
    super.dispose();
  }

  JobInfoDetailResponse get jobDetail => _jobDetail;

  set jobDetail(JobInfoDetailResponse value) {
    if (_jobDetail == value) return;
    _jobDetail = value;
    notifyListeners();
  }
}


class QuotationItem {
  QuotationItemType type;
  TextEditingController productController;
  TextEditingController qtyController;
  TextEditingController unitPriceController;

  QuotationItem({
    required this.type,
    required this.productController,
    required this.qtyController,
    required this.unitPriceController,
  });

  double get lineTotal {
    final price = double.tryParse(unitPriceController.text) ?? 0;
    if (type == QuotationItemType.service) {
      return price;
    }
    final qty = double.tryParse(qtyController.text) ?? 0;
    return qty * price;
  }


  factory QuotationItem.empty(QuotationItemType type) {
    return QuotationItem(
      type: type,
      productController: TextEditingController(),
      qtyController: TextEditingController(),
      unitPriceController: TextEditingController(),
    );
  }

  void dispose() {
    productController.dispose();
    qtyController.dispose();
    unitPriceController.dispose();
  }
}

