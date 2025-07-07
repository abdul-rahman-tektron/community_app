import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/modules/customer/dashboard/dashboard_screen.dart';
import 'package:community_app/modules/customer/explore/explore_screen.dart';
import 'package:community_app/modules/customer/services/services_screen.dart';
import 'package:flutter/material.dart';

class BottomBarNotifier extends BaseChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  BottomBarNotifier(int? currentIndex) {
    _currentIndex = currentIndex ?? 0;
  }

  void changeTab(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  final List<Widget> _screens = [
    CustomerDashboardScreen(),
    ExploreScreen(),
    ServicesScreen(),
  ];

  Widget get currentScreen => _screens[_currentIndex];
}