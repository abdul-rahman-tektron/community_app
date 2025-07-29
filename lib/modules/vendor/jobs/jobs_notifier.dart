import 'package:community_app/core/base/base_notifier.dart';

class JobsNotifier extends BaseChangeNotifier{
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    if (_selectedIndex == value) return;
    _selectedIndex = value;
    notifyListeners();
  }
}