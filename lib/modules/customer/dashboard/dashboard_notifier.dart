import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/core/model/customer/dashboard/customer_dashboard_response.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_dashboard_repository.dart';
import 'package:community_app/modules/vendor/dashboard/dashboard_notifier.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomerDashboardNotifier extends BaseChangeNotifier {
  List<ServiceDropdownData> categoriesData = [];

  String? _ongoingJobs;
  String? _completedJobs;
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

  CustomerDashboardNotifier() {
    initializeData();
  }

  Future<void> initializeData() async {
    await loadUserData();
    await apiServiceDropdown();
    await apiDashboard();
  }

  List<QuickStat> get quickStats {
    return [
      QuickStat(
        icon: LucideIcons.arrowUpNarrowWide,
        iconColor: Colors.blue,
        iconBgColor: Colors.blue.withOpacity(0.1),
        label: "Ongoing",
        count: ongoingJobs ?? '0',
      ),
      QuickStat(
        icon: LucideIcons.check,
        iconColor: Colors.green,
        iconBgColor: Colors.green.withOpacity(0.1),
        label: "Completed",
        count: completedJobs ?? '0',
      ),
    ];
  }

  // Quick actions
  final List<QuickAction> quickActions = [
    QuickAction(icon: LucideIcons.circlePlus300, label: 'New Service'),
    QuickAction(icon: LucideIcons.receiptText300, label: 'Pending Quotation'),
    QuickAction(icon: LucideIcons.mapPin300, label: 'Track Request'),
    QuickAction(icon: LucideIcons.circleDollarSign300, label: 'Make Payment'),
  ];

  IconData getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case "plumbing":
        return LucideIcons.wrench300;
      case "painting":
        return LucideIcons.paintRoller300;
      case "cleaning":
        return LucideIcons.brushCleaning300;
      case "electric works":
        return LucideIcons.unplug300;
      case "ac repair":
        return LucideIcons.airVent300;
      case "laundry":
        return LucideIcons.washingMachine300;
      case "pet grooming":
        return LucideIcons.scissors300;
      case "carpentry":
        return LucideIcons.hammer300;
      case "appliance repair":
        return LucideIcons.trafficCone300;
      case "pest control":
        return LucideIcons.bug300;
      case "security & cctv":
        return LucideIcons.cctv300;
      case "handyman services":
        return LucideIcons.drill300;
      default:
        return LucideIcons.circle300; // fallback icon
    }
  }


  void selectCategory(BuildContext context, ServiceDropdownData category) {
    print("category.serviceName");
    print(category.serviceName);
    print(category.serviceId);
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.customerBottomBar,
      arguments: {'currentIndex': 1, 'category': category.serviceId.toString()},
    );

    notifyListeners();
  }

  Future<void> apiServiceDropdown() async {
    try {
      final result = await CommonRepository.instance.apiServiceDropdown();

      if (result is List<ServiceDropdownData>) {
        categoriesData = result;
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiServiceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiServiceDropdown: $e");
    }
  }

  Future<void> apiDashboard() async {
    try {
      final result = await CustomerDashboardRepository.instance.apiCustomerDashboard(userData?.customerId.toString() ?? "0");

      if (result is CustomerDashboardResponse) {
        ongoingJobs = result.jobstats?.ongoing.toString() ?? "0";
        completedJobs = result.jobstats?.completed.toString() ?? "0";
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiDashboard");
      }
    } catch (e) {
      debugPrint("Error in apiDashboard: $e");
    }
  }

  int currentPromotionIndex = 0;

  void updatePromotionIndex(int index) {
    currentPromotionIndex = index;
    notifyListeners();
  }

  String? get ongoingJobs => _ongoingJobs;

  set ongoingJobs(String? value) {
    if (_ongoingJobs == value) return;
    _ongoingJobs = value;
      notifyListeners();
  }

  String? get completedJobs => _completedJobs;

  set completedJobs(String? value) {
    if (_completedJobs == value) return;
    _completedJobs = value;
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


// class ServiceCategory {
//   final String name;
//   final IconData icon;
//
//   const ServiceCategory({required this.name, required this.icon});
// }