import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:community_app/core/remote/services/service_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';

class QuotationListNotifier extends BaseChangeNotifier {
  final List<int> _selected = [];
  List<QuotationRequestListData> jobs = [];
  bool isLoading = true;

  QuotationListNotifier() {
    initializeData();
  }

  initializeData() async {
    await apiQuotationRequestList();
  }

  Future<void> apiQuotationRequestList() async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = await ServiceRepository().apiQuotationRequestList("20030") as QuotationRequestListResponse;

      if (parsed.success == true && parsed.data != null) {
        jobs = parsed.data!;
      }
    } catch (e, stackTrace) {
      print("Error fetching quotation requests: $e");
      print("Stack: $stackTrace");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  bool isSelected(int index) => _selected.contains(index);

  void toggle(int index) {
    if (_selected.contains(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    notifyListeners();
  }

  List<int> get selectedIndexes => _selected;
}
