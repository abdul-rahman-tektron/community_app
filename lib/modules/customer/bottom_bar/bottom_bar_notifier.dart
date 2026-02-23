import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/modules/customer/dashboard/dashboard_screen.dart';
import 'package:Xception/modules/customer/explore/explore_screen.dart';
import 'package:Xception/modules/customer/jobs/jobs_screen.dart';
import 'package:Xception/utils/enums.dart';
import 'package:flutter/material.dart';

class BottomBarNotifier extends BaseChangeNotifier {
  int _currentIndex = 0;
  String? _selectedCategory;
  int _subCurrentIndex = 0;
  bool? _isPayment = false;

  int get currentIndex => _currentIndex;
  String? get selectedCategory => _selectedCategory;
  int get subCurrentIndex => _subCurrentIndex;
  bool get isPayment => _isPayment ?? false;

  BottomBarNotifier(int? currentIndex, [String? initialCategory, int? subCurrentIndex, bool? isPayment]) {
    initNotifier();
    _currentIndex = currentIndex ?? 0;
    _selectedCategory = initialCategory;
    _subCurrentIndex = subCurrentIndex ?? 0;
    _isPayment = isPayment;
  }

  Future<void> initNotifier() async {
    await loadUserRole();
  }

  void changeTab(int index, {String? category, bool? isPayment}) {
    _currentIndex = index;
    _selectedCategory = category;

    // ✅ Only set true when caller explicitly asks.
    // Otherwise reset.
    if (index != 2) _isPayment = false;
    notifyListeners();
  }

  void changeSubTab(int subIndex, {bool? isPayment}) {
    _subCurrentIndex = subIndex;

    // ✅ If not explicitly passed, reset
    _isPayment = isPayment ?? false;

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
      JobsScreen(currentIndex: _subCurrentIndex, isPayment: isPayment),
    ][_currentIndex];
  }
}

