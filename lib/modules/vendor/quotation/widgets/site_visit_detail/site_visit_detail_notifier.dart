import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/site_visit_assign_employee_request.dart';
import 'package:community_app/core/remote/services/vendor/vendor_jobs_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class AssignedEmployee {
  final String name;
  final String phone;
  final File? emiratesId;

  AssignedEmployee({required this.name, required this.phone, this.emiratesId});
}

class SiteVisitDetailNotifier extends BaseChangeNotifier {
  final String? jobId;

  SiteVisitDetailNotifier(this.jobId, this.customerId, this.siteVisitId);

  bool isLoading = false;
  bool isEmployeeAssigned = false;
  bool isQuotationUpdated = false;
  int? customerId;
  int? siteVisitId;

  List<AssignedEmployee> assignedEmployees = [];

  Future<void> loadDetails() async {
    isLoading = true;
    notifyListeners();

    try {
      // TODO: Call API to fetch site visit request details by requestId
      // Example:
      // final response = await VendorJobsRepository.instance.apiSiteVisitDetail(requestId);

      // Simulating:
      await Future.delayed(const Duration(seconds: 1));
      isEmployeeAssigned = false;
      isQuotationUpdated = false;
    } catch (e) {
      ToastHelper.showError("Failed to load details: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void addEmployee(String name, String phone, {File? emiratesId}) {
    assignedEmployees.add(AssignedEmployee(name: name, phone: phone, emiratesId: emiratesId));
    notifyListeners();
  }

  void removeEmployee(AssignedEmployee employee) {
    assignedEmployees.remove(employee);
    notifyListeners();
  }

  Future<void> submitAssignedEmployees() async {
    if (assignedEmployees.isEmpty) {
      ToastHelper.showError("Please add at least one employee.");
      return;
    }

    try {
      final request = SiteVisitAssignEmployeeRequest(
        siteVisitId: int.parse(jobId ?? "0"),
        assignEmployeeList: await Future.wait(
          assignedEmployees.map((e) async {
            final base64Id = e.emiratesId != null ? await e.emiratesId!.toBase64() : null;
            return AssignEmployeeList(
              employeeName: e.name,
              employeePhoneNumber: e.phone,
              emiratesIdPhoto: base64Id,
            );
          }),
        ),
      );

      final response = await VendorQuotationRepository.instance.apiSiteVisitAssignEmployee(request);

      if (response is CommonResponse && response.success == true) {
        isEmployeeAssigned = true;
        ToastHelper.showSuccess("Employees assigned successfully");
      } else {
        ToastHelper.showError(response is CommonResponse ? response.message ?? "" : "Failed to assign employees");
      }
    } catch (e) {
      ToastHelper.showError("Error submitting employees: $e");
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

  Future<void> declineRequest() async {
    try {
      // TODO: API call to decline site visit
      ToastHelper.showSuccess("Request declined successfully");
    } catch (e) {
      ToastHelper.showError("Failed to decline request: $e");
    }
  }
}