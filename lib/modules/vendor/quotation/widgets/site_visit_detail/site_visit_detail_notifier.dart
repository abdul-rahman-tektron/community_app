import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/site_visit_assign_employee_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_jobs_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class AssignedEmployee {
  final String name;
  final String phone;
  final String? emiratesIdNumber;
  final File? emiratesId;

  AssignedEmployee({
    required this.name,
    required this.phone,
    this.emiratesIdNumber,
    this.emiratesId,
  });
}

class SiteVisitDetailNotifier extends BaseChangeNotifier {
  final String? jobId;

  SiteVisitDetailNotifier(this.jobId, this.customerId, this.siteVisitId, this.vendorId) {
    runWithLoadingVoid(() => initializeData());
  }

  initializeData() async {
    await loadUserData();
    await apiJobInfoDetail();
  }

  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();

  bool isEmployeeAssigned = false;
  bool isQuotationUpdated = false;
  int? customerId;
  int? siteVisitId;
  int? vendorId;

  List<AssignedEmployee> assignedEmployees = [];

  Future<void> apiJobInfoDetail() async {
    try {
      final result = await VendorDashboardRepository.instance.apiJobInfoDetail(
        jobId?.toString() ?? "0",
      );

      if (result is JobInfoDetailResponse) {
        jobDetail = result;
      } else {
        debugPrint("Unexpected result type from apiJobInfoDetail");
      }
    } catch (e) {
      debugPrint("Error in apiJobInfoDetail: $e");
    }
  }

  void addEmployee(String name, String phone, {String? emiratesIdNumber, File? emiratesId}) {
    assignedEmployees.add(
      AssignedEmployee(
        name: name,
        phone: phone,
        emiratesIdNumber: emiratesIdNumber,
        emiratesId: emiratesId,
      ),
    );
    notifyListeners();
  }

  void removeEmployee(AssignedEmployee employee) {
    assignedEmployees.remove(employee);
    notifyListeners();
  }

  Future<void> submitAssignedEmployees(BuildContext context) async {
    if (assignedEmployees.isEmpty) {
      ToastHelper.showError("Please add at least one employee.");
      return;
    }

    try {
      final request = SiteVisitAssignEmployeeRequest(
        siteVisitId: siteVisitId,
        customerId: customerId,
        jobId: int.tryParse(jobId ?? "0"),
        assignEmployeeList: await Future.wait(
          assignedEmployees.map((e) async {
            final base64Id = e.emiratesId != null ? await e.emiratesId!.toBase64() : null;
            return AssignEmployeeList(
              employeeName: e.name,
              employeePhoneNumber: e.phone,
              emiratesIdNumber: e.emiratesIdNumber,
              emiratesIdPhoto: base64Id,
            );
          }),
        ),
      );

      final response = await VendorQuotationRepository.instance.apiSiteVisitAssignEmployee(request);

      if (response is CommonResponse && response.success == true) {
        isEmployeeAssigned = true;
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

  Future<void> apiUpdateJobStatus(
    BuildContext context,
    int? statusId, {
    bool? isReject = false,
  }) async {
    if (statusId == null) return;
    try {
      notifyListeners();

      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(
          jobId: int.parse(jobId ?? "0"),
          statusId: statusId,
          vendorId: vendorId,
          createdBy: userData?.name ?? "",
        ),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        if (isReject ?? false) ToastHelper.showSuccess("Quotation Rejected successfully!");
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

  void navigateToUpdateQuotation(BuildContext context) {
    // TODO: Navigate to quotation screen
    // After update:
    isQuotationUpdated = true;
    notifyListeners();
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> declineRequest(BuildContext context) async {
    try {
      await apiUpdateJobStatus(context, AppStatus.employeeAssigned.id);
      // ToastHelper.showSuccess("Request declined successfully");
    } catch (e) {
      ToastHelper.showError("Failed to decline request: $e");
    }
  }

  JobInfoDetailResponse get jobDetail => _jobDetail;

  set jobDetail(JobInfoDetailResponse value) {
    if (_jobDetail == value) return;
    _jobDetail = value;
    notifyListeners();
  }
}
