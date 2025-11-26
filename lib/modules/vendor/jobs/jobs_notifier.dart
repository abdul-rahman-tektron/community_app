import 'package:Xception/core/base/base_notifier.dart';

class JobsNotifier extends BaseChangeNotifier{
  int _selectedIndex = 0;

  JobsNotifier(int? currentIndex) {
    _selectedIndex = currentIndex ?? 0;
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    if (_selectedIndex == value) return;
    _selectedIndex = value;
    notifyListeners();
  }
}