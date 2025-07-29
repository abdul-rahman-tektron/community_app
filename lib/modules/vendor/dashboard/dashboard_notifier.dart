import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class VendorDashboardNotifier extends ChangeNotifier {
  // License status data
  final LicenseStatus licenseStatus = LicenseStatus(
    licenseId: "1234567890",
    expiryDate: DateTime(2025, 12, 31),
    status: "Active",
  );

  // Quick stats list (light background + dark icon)
  final List<QuickStat> quickStats = [
    QuickStat(
      icon: LucideIcons.circlePlus,
      iconBgColor: const Color(0xffe7f0ff), // Light blue
      iconColor: Colors.blue.shade700,
      count: 12,
      label: "New Requests",
    ),
    QuickStat(
      icon: LucideIcons.receiptText,
      iconBgColor: const Color(0xfffff6e8), // Light orange
      iconColor: Colors.orange.shade700,
      count: 5,
      label: "Quotation Awaiting",
    ),
    QuickStat(
      icon: LucideIcons.wrench,
      iconBgColor: const Color(0xffe8f7e8), // Light green
      iconColor: Colors.green.shade700,
      count: 7,
      label: "Service In Progress",
    ),
    QuickStat(
      icon: LucideIcons.creditCard,
      iconBgColor: const Color(0xffffe8e8), // Light red
      iconColor: Colors.red.shade700,
      count: 3,
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
  final int count;
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
