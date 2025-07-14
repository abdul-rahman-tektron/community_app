import 'package:community_app/core/base/base_notifier.dart';

class TopVendorsNotifier extends BaseChangeNotifier {
  /// Holds indexes (or ids) of the selected vendor cards
  final List<int> _selected = [];

  List<int> get selected => _selected;

  bool isSelected(int index) => _selected.contains(index);

  void toggle(int index) {
    if (isSelected(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    notifyListeners();
  }
}
