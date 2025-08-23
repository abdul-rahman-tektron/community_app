import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/dashboard/vendor_dashboard_response.dart';
import 'package:community_app/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class VendorDashboardNotifier extends BaseChangeNotifier {

  int? _acceptedCount = 0;
  int? _rejectedCount = 0;
  int? _newRequest = 0;
  int? _awaitingQuotation = 0;
  int? _inProgress = 0;
  int? _pendingPayment = 0;

  Document? documentData;

  VendorDashboardNotifier() {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await apiDashboard();
  }

  // License status data
  final LicenseStatus licenseStatus = LicenseStatus(
    licenseId: "1234567890",
    expiryDate: DateTime(2025, 12, 31),
    status: "Active",
  );

  Future<void> apiDashboard() async {
    try {
      final result = await VendorDashboardRepository.instance.apiVendorDashboard(userData?.customerId.toString() ?? "0");

      if (result is VendorDashboardResponse) {
        newRequest = result.stats?.newRequest ?? 0;
        awaitingQuotation = result.stats?.awaitingQuotation ?? 0;
        inProgress = result.stats?.inProgress ?? 0;
        pendingPayment = result.stats?.pendingPayment ?? 0;
        acceptedCount = result.stats?.accepted ?? 0;
        rejectedCount = result.stats?.rejected ?? 0;
        documentData = result.documents?.first;
        print("acceptedCount test");
        print(acceptedCount);
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiDashboard");
      }
    } catch (e) {
      debugPrint("Error in apiDashboard: $e");
    }
  }

  // Quick stats list (light background + dark icon)
  List<QuickStat> get quickStats => [
    QuickStat(
      icon: LucideIcons.circlePlus,
      iconBgColor: const Color(0xffe7f0ff), // Light blue
      iconColor: Colors.blue.shade700,
      count: newRequest?.toString() ?? "0",  // your dynamic variable here
      label: "New Requests",
    ),
    QuickStat(
      icon: LucideIcons.receiptText,
      iconBgColor: const Color(0xfffff6e8), // Light orange
      iconColor: Colors.orange.shade700,
      count: awaitingQuotation?.toString() ?? "0",  // your dynamic variable here
      label: "Quotation Awaiting",
    ),
    QuickStat(
      icon: LucideIcons.wrench,
      iconBgColor: const Color(0xffe8f7e8), // Light green
      iconColor: Colors.green.shade700,
      count: inProgress?.toString() ?? "0",  // your dynamic variable here
      label: "Service In Progress",
    ),
    QuickStat(
      icon: LucideIcons.creditCard,
      iconBgColor: const Color(0xffffe8e8), // Light red
      iconColor: Colors.red.shade700,
      count: pendingPayment?.toString() ?? "0",  // your dynamic variable here
      label: "Payment Pending",
    ),
  ];


  // Quick actions list (same style)
  final List<QuickAction> quickActions = [
    QuickAction(
      icon: LucideIcons.squarePlus,
      iconBgColor: const Color(0xffe7f0ff),
      iconColor: Colors.blue.shade800,
      label: "View New Request",
    ),
    QuickAction(
      icon: LucideIcons.squareChartGantt,
      iconBgColor: const Color(0xffe7f0ff),
      iconColor: Colors.blue.shade800,
      label: "Manage Quotation",
    ),
    QuickAction(
      icon: LucideIcons.userRound,
      iconBgColor: const Color(0xffe7f0ff),
      iconColor: Colors.blue.shade800,
      label: "Assign Employee",
    ),
    QuickAction(
      icon: LucideIcons.history,
      iconBgColor: const Color(0xffe7f0ff),
      iconColor: Colors.blue.shade800,
      label: "Service History",
    ),
  ];

  // Alerts list
  final List<AlertItem> alerts = [
    AlertItem(
      icon: LucideIcons.messageSquareMore,
      iconBgColor: const Color(0xfffff6e8),
      iconColor: Colors.orange.shade900,
      message: "5 requests have not been responded to for over 24 hours",
    ),
    AlertItem(
      icon: LucideIcons.creditCard,
      iconBgColor: const Color(0xffffe8e8),
      iconColor: Colors.red.shade900,
      message: "3 payments are pending from completed services",
    ),
  ];

  int? get acceptedCount => _acceptedCount;

  set acceptedCount(int? value) {
    if (_acceptedCount == value) return;
    _acceptedCount = value;
    notifyListeners();
  }

  int? get rejectedCount => _rejectedCount;

  set rejectedCount(int? value) {
    if (_rejectedCount == value) return;
    _rejectedCount = value;
    notifyListeners();
  }

  int? get newRequest => _newRequest;

  set newRequest(int? value) {
    if (_newRequest == value) return;
    _newRequest = value;
    notifyListeners();
  }

  int? get awaitingQuotation => _awaitingQuotation;

  set awaitingQuotation(int? value) {
    if (_awaitingQuotation == value) return;
    _awaitingQuotation = value;
    notifyListeners();
  }

  int? get inProgress => _inProgress;

  set inProgress(int? value) {
    if (_inProgress == value) return;
    _inProgress = value;
    notifyListeners();
  }

  int? get pendingPayment => _pendingPayment;

  set pendingPayment(int? value) {
    if (_pendingPayment == value) return;
    _pendingPayment = value;
    notifyListeners();
  }
}

class LicenseStatus {
  final String licenseId;
  final DateTime expiryDate;
  final String status;

  LicenseStatus({
    required this.licenseId,
    required this.expiryDate,
    required this.status,
  });
}

class QuickStat {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String? count;
  final String label;

  QuickStat({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.count,
    required this.label,
  });
}

class QuickAction {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;

  QuickAction({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
  });
}

class AlertItem {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String message;

  AlertItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.message,
  });
}
