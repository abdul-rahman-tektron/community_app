import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:Xception/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:Xception/core/model/vendor/quotation_request/quotation_response_detail_response.dart';
import 'package:Xception/core/model/vendor/quotation_request/site_visit_assign_employee_request.dart';
import 'package:Xception/core/model/vendor/vendor_quotation/create_job_quotation_request.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:Xception/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class AddQuotationNotifier extends BaseChangeNotifier {
  List<QuotationItem> quotationItems = [];

  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();

  int? jobId;
  int? serviceId;
  int? quotationId;
  int? customerId;
  int? quotationResponseId;
  bool? isResend;

  QuotationResponseDetailResponse _quotationDetail = QuotationResponseDetailResponse();

  final TextEditingController notesController = TextEditingController();

  double get subTotal =>
      quotationItems.fold(0, (sum, item) => sum + item.lineTotal);

  double get vat => subTotal * 0.05;

  double get grandTotal => subTotal + vat;

  AddQuotationNotifier() {
    runWithLoadingVoid(() => initializeData());
  }

  initializeData() async {
    await loadUserData();
    await apiJobInfoDetail();

    // If it is resend, fetch quotation details and populate fields
    if (isResend ?? false) {
      await apiQuotationResponseDetail();

      if (_quotationDetail.items != null && _quotationDetail.items!.isNotEmpty) {
        quotationItems.clear(); // Remove default empty items

        // Add items from API
        for (var item in _quotationDetail.items!) {
          // If quantity is 0 or null, treat it as service, else material
          final type = (item.quantity == null || item.quantity == 0)
              ? QuotationItemType.service
              : QuotationItemType.material;

          quotationItems.add(
            QuotationItem(
              type: type,
              productController: TextEditingController(text: item.product ?? ''),
              qtyController: TextEditingController(text: item.quantity?.toString() ?? '0'),
              unitPriceController: TextEditingController(text: item.price?.toStringAsFixed(2) ?? '0'),
            ),
          );
        }
      } else {
        // If no items, add default empty rows
        quotationItems.add(QuotationItem.empty(QuotationItemType.material));
        quotationItems.add(QuotationItem.empty(QuotationItemType.service));
      }

      // Populate notes / description field
      notesController.text = _quotationDetail.quotationDetails ?? '';
    } else {
      // Normal flow: just add empty rows
      quotationItems.add(QuotationItem.empty(QuotationItemType.material));
      quotationItems.add(QuotationItem.empty(QuotationItemType.service));
    }

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

  Future<void> apiQuotationResponseDetail() async {
    try {
      final result = await VendorQuotationRepository.instance.apiQuotationDetail(quotationResponseId?.toString() ?? "0");

      if (result is QuotationResponseDetailResponse) {
        quotationDetail = result;

        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiQuotationResponseDetail");
      }
    } catch (e) {
      debugPrint("Error in apiQuotationResponseDetail: $e");
    }
  }

  Future<void> apiUpdateJobStatus(BuildContext context, int? statusId,
      {bool? isReject = false}) async {
    if (statusId == null) return;
    try {
      notifyListeners();

      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId, createdBy: userData?.name ?? "", vendorId: userData?.customerId ?? 0),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        if(isReject ?? false) ToastHelper.showSuccess("Quotation Rejected successfully!");
        Navigator.pop(context);
      }

    } catch (e, stackTrace) {
      print("❌ Error updating job status: $e");
      print("Stack: $stackTrace");
      // ToastHelper.showError('An error occurred. Please try again.');
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

  Future<void> submitAssignedEmployees(
      BuildContext context,
      int siteVisitId, {
        required String employeeName,
        required String phone,
        required String emiratesId,
      }) async {
    try {
      final request = SiteVisitAssignEmployeeRequest(
        siteVisitId: siteVisitId,
        customerId: customerId,
        jobId: jobId ?? 0,
        assignEmployeeList: [
          AssignEmployeeList(
            employeeName: employeeName,
            employeePhoneNumber: phone,
            emiratesIdNumber: emiratesId,
            emiratesIdPhoto: null, // add image upload later if needed
          ),
        ],
      );

      final response = await VendorQuotationRepository.instance.apiSiteVisitAssignEmployee(request);

      if (response is CommonResponse && response.success == true) {
        await apiUpdateJobStatus(context, AppStatus.employeeAssigned.id);
        ToastHelper.showSuccess("Employees assigned successfully");
      } else {
        ToastHelper.showError(
          response is CommonResponse ? response.message ?? "" : "Failed to assign employees",
        );
      }
    } catch (e) {
      ToastHelper.showError("Error submitting employees: $e");
    } finally {
      notifyListeners();
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

  QuotationResponseDetailResponse get quotationDetail => _quotationDetail;

  set quotationDetail(QuotationResponseDetailResponse value) {
    if (_quotationDetail == value) return;
    _quotationDetail = value;
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
      productController: TextEditingController(
        text: type == QuotationItemType.service ? 'Labour Charge' : '',
      ),
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

