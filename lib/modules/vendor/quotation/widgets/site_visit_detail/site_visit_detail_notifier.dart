import 'dart:io';
import '../../../jobs/widgets/ongoing_service/progress_update/progress_update_notifier.dart';
import 'package:flutter/material.dart';
import 'package:community_app/utils/router/routes.dart';

class SiteVisitDetailNotifier extends ChangeNotifier {
  final String requestId;

  SiteVisitDetailNotifier(this.requestId);

  // Mocked detail fields
  String customerName = "";
  String serviceName = "";
  String phone = "";
  String location = "";
  String requestedDate = "";
  String jobDescription = "";
  String status = "Pending";

  // Step flags
  bool isLoading = true;
  bool isEmployeeAssigned = false;
  bool isQuotationUpdated = false;

  List<AssignedEmployee> assignedEmployees = []; // <-- Now using model

  void addEmployee(String name, String phone, {File? emiratesId}) {
    assignedEmployees.add(AssignedEmployee(name: name, phone: phone, emiratesId: emiratesId));
    notifyListeners();
  }

  void removeEmployee(AssignedEmployee employee) {
    assignedEmployees.remove(employee);
    notifyListeners();
  }

  Future<void> submitAssignedEmployees() async {
    // Call API to submit employees
    isEmployeeAssigned = true;
    notifyListeners();
  }

  Future<void> loadDetails() async {
    await Future.delayed(const Duration(milliseconds: 500));
    customerName = "John Doe";
    serviceName = "Plumbing Repair";
    phone = "+971 50 123 4567";
    location = "Dubai Marina, Dubai";
    requestedDate = "2025-07-28";
    jobDescription = "Fixing leakage in the kitchen sink and checking bathroom pipes.";
    status = "Pending";
    isLoading = false;
    notifyListeners();
  }

  void navigateToUpdateQuotation(BuildContext context) {
    Navigator.pushNamed(context, '/add-quotation').then((_) {
      isQuotationUpdated = true;
      status = "Quotation Updated";
      notifyListeners();
    });
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.vendorBottomBar, arguments: 0);
  }

  void acceptRequest() {
    status = "Accepted";
    notifyListeners();
  }

  void declineRequest() {
    status = "Declined";
    notifyListeners();
  }
}
