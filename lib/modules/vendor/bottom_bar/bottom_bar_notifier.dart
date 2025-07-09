import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/modules/vendor/dashboard/dashboard_screen.dart';
import 'package:community_app/modules/vendor/jobs/jobs_screen.dart';
import 'package:community_app/modules/vendor/quotation/quotation_screen.dart';
import 'package:flutter/material.dart';

class VendorBottomBarNotifier extends BaseChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  VendorBottomBarNotifier(int? currentIndex) {
    initNotifier();
    _currentIndex = currentIndex ?? 0;
  }

  Future<void> initNotifier() async {
    await loadUserRole();
  }
  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    VendorDashboardScreen(),
    QuotationScreen(),
    JobsScreen(),
  ];

  Widget get currentScreen => _screens[_currentIndex];
}