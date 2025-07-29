import 'package:flutter/material.dart';

class SiteVisitRequest {
  final String id;
  final String customerName;
  final String serviceName;
  final String requestedDate;

  SiteVisitRequest({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.requestedDate,
  });
}

class SiteVisitNotifier extends ChangeNotifier {
  List<SiteVisitRequest> siteVisits = [];

  Future<void> loadSiteVisits() async {
    // Mock delay for loading
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data
    siteVisits = [
      SiteVisitRequest(
        id: "1",
        customerName: "John Doe",
        serviceName: "Plumbing Repair",
        requestedDate: "2025-07-28",
      ),
      SiteVisitRequest(
        id: "2",
        customerName: "Sarah Smith",
        serviceName: "Electrical Maintenance",
        requestedDate: "2025-07-27",
      ),
      SiteVisitRequest(
        id: "3",
        customerName: "Michael Brown",
        serviceName: "AC Service",
        requestedDate: "2025-07-25",
      ),
    ];

    notifyListeners();
  }
}
