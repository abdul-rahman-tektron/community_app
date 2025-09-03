import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/modules/customer/dashboard/dashboard_screen.dart';
import 'package:community_app/modules/customer/explore/explore_screen.dart';
import 'package:community_app/modules/customer/jobs/jobs_screen.dart';
import 'package:community_app/utils/enums.dart';
import 'package:flutter/material.dart';

class BottomBarNotifier extends BaseChangeNotifier {
  int _currentIndex = 0;
  String? _selectedCategory;

  int get currentIndex => _currentIndex;
  String? get selectedCategory => _selectedCategory;

  BottomBarNotifier(int? currentIndex, [String? initialCategory]) {
    initNotifier();
    _currentIndex = currentIndex ?? 0;
    _selectedCategory = initialCategory;
  }

  Future<void> initNotifier() async {
    await loadUserRole();
  }

  void changeTab(int index, {String? category}) {
    _currentIndex = index;
    _selectedCategory = category;
    notifyListeners();
  }

  Widget get currentScreen {
    return [
      CustomerDashboardScreen(
        onCategoryTap: (category) {
          changeTab(1, category: category.serviceId.toString()); // pass category name
        },
      ),
      ExploreScreen(initialCategory: _selectedCategory), // Pass the selected category here too
      JobsScreen(),
    ][_currentIndex];
  }
}

