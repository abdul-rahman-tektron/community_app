import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/modules/vendor/dashboard/dashboard_notifier.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomerDashboardNotifier extends BaseChangeNotifier {
  final List<PromotionItem> promotions = [
    PromotionItem(
      title: "Get 20% off on AC Repair!",
      imageUrl: "https://inotec.ae/wp-content/uploads/2024/03/air-conditioner-cleaning-and-man-with-electrical-machine-check-in-a-home-with-ac-repair-maintenan-1024x683.jpg",
    ),
    PromotionItem(
      title: "Free inspection for pest control",
      imageUrl: "https://techsquadteam.com/assets/profile/blogimages/2d6d0e31d02d7fc9cd2fb2310f49153c.jpg",
    ),
    PromotionItem(
      title: "Buy 1 Cleaning, Get 1 Free",
      imageUrl: "https://diamondshine.com.ng/storage/2021/04/diamond-shine-cleaning-services-2.jpg",
    ),
  ];

  final List<Color> chipIconColors = [
    Color(0xFF64B5F6), // Blue 300
    Color(0xFFFFB74D), // Orange 300
    Color(0xFF81C784), // Green 300
    Color(0xFFBA68C8), // Purple 300
    Color(0xFF9575CD), // Deep Purple 300
    Color(0xFFE57373), // Red 300
    Color(0xFFFFD54F), // Amber 300
    Color(0xFF4DD0E1), // Cyan 300
    Color(0xFFDCE775), // Lime 300
    Color(0xFF90A4AE), // Blue Grey 300
  ];





  final List<QuickStat> quickStats = [
    QuickStat(
      icon: LucideIcons.arrowUpNarrowWide,
      iconBgColor: const Color(0xffe7f0ff), // Light blue
      iconColor: Colors.blue.shade700,
      count: 12,
      label: "Ongoing",
    ),
    QuickStat(
      icon: LucideIcons.check,
      iconBgColor: const Color(0xffe8f7e8), // Light orange
      iconColor: Colors.green.shade700,
      count: 5,
      label: "Completed",
    ),
  ];

  // Categories
  List<ServiceCategory> categories = [
    ServiceCategory(name: 'All', icon: LucideIcons.shapes),
    ServiceCategory(name: 'AC Repair', icon: LucideIcons.airVent),
    ServiceCategory(name: 'Plumbing', icon: LucideIcons.toilet),
    ServiceCategory(name: 'Cleaning', icon: LucideIcons.brushCleaning),
    ServiceCategory(name: 'Painting', icon: LucideIcons.paintRoller),
    ServiceCategory(name: 'Pest Control', icon: LucideIcons.bug),
  ];

  // Service counts
  int ongoingCount = 2;
  int completedCount = 7;

  // Quick actions
  final List<QuickAction> quickActions = [
    QuickAction(icon: LucideIcons.circlePlus, label: 'New Service'),
    QuickAction(icon: LucideIcons.receiptText, label: 'Pending Quotation'),
    QuickAction(icon: LucideIcons.mapPin, label: 'Track Request'),
    QuickAction(icon: LucideIcons.circleDollarSign, label: 'Make Payment'),
  ];

  void selectCategory(BuildContext context, ServiceCategory category) {
    print(category.name);
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.customerBottomBar,
      arguments: {'currentIndex': 1, 'category': category},
    );

    notifyListeners();
  }

  int currentPromotionIndex = 0;

  void updatePromotionIndex(int index) {
    currentPromotionIndex = index;
    notifyListeners();
  }
}

class QuickAction {
  final IconData icon;
  final String label;

  QuickAction({required this.icon, required this.label});
}

class PromotionItem {
  final String title;
  final String imageUrl;

  PromotionItem({required this.title, required this.imageUrl});
}


class ServiceCategory {
  final String name;
  final IconData icon;

  const ServiceCategory({required this.name, required this.icon});
}