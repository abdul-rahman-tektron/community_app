import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/modules/vendor/dashboard/dashboard_screen.dart';
import 'package:Xception/modules/vendor/jobs/jobs_screen.dart';
import 'package:Xception/modules/vendor/quotation/quotation_screen.dart';
import 'package:flutter/material.dart';

class VendorBottomBarNotifier extends BaseChangeNotifier {
  int _currentIndex = 0;
  int _subCurrentIndex = 0;
  bool? _isPayment = false;

  int get currentIndex => _currentIndex;
  int get subCurrentIndex => _subCurrentIndex;
  bool? get isPayment => _isPayment ?? false;

  VendorBottomBarNotifier(int? currentIndex, int? subCurrentIndex, bool? isPayment) {
    initNotifier();
    _currentIndex = currentIndex ?? 0;
    _subCurrentIndex = subCurrentIndex ?? 0;
    _isPayment = isPayment;
  }

  Future<void> initNotifier() async {
    await loadUserRole();
  }

  void changeTab(int index) {
    _currentIndex = index;

    if (index != 2) _isPayment = false;
    notifyListeners();
  }

  void changeSubTab(int subIndex) {
    _subCurrentIndex = subIndex;
    _isPayment = false;
    notifyListeners();
  }

  List<Widget> get _screens => [
    VendorDashboardScreen(),
    QuotationScreen(currentIndex: _subCurrentIndex),
    JobsScreen(currentIndex: _subCurrentIndex, isPayment: _isPayment),
  ];

  Widget get currentScreen => _screens[_currentIndex];
}
