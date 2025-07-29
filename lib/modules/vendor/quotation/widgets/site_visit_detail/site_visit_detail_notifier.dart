import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

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

  List<Map<String, String>> assignedEmployees = []; // name, phone

  void addEmployee(String name, String phone) {
    assignedEmployees.add({'name': name, 'phone': phone});
    notifyListeners();
  }

  void removeEmployee(Map<String, String> employee) {
    assignedEmployees.remove(employee);
    notifyListeners();
  }

  Future<void> submitAssignedEmployees() async {
    // Call API to submit employees
    // On success:
    isEmployeeAssigned = true;
    notifyListeners();
  }

  Future<void> loadDetails() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
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
    // Navigate to existing AddQuotationScreen or a new one
    // Example:
    Navigator.pushNamed(context, '/add-quotation').then((_) {
      // After returning from quotation screen
      isQuotationUpdated = true;
      status = "Quotation Updated";
      notifyListeners();
    });
  }

  void navigateToHomeScreen(BuildContext context) {
    // Navigate to existing AddQuotationScreen or a new one
    // Example:
    Navigator.pushNamed(context, AppRoutes.vendorBottomBar, arguments: 0);
  }

  void acceptRequest() {
    status = "Accepted";
    notifyListeners();
    // API call for accepting can go here
  }

  void declineRequest() {
    status = "Declined";
    notifyListeners();
    // API call for declining can go here
  }
}
