import 'package:community_app/core/base/base_notifier.dart';

class QuotationNotifier extends BaseChangeNotifier {

  int _selectedIndex = 0;

  QuotationNotifier(int? currentIndex) {
    selectedIndex = currentIndex ?? 0;
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    if (_selectedIndex == value) return;
    _selectedIndex = value;
    notifyListeners();
  }
}