import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/user/customer_id_request.dart';
import 'package:community_app/core/model/vendor/jobs/vendor_history_list.dart';
import 'package:community_app/core/remote/services/vendor/vendor_jobs_repository.dart';

class JobHistoryNotifier extends BaseChangeNotifier {
  List<Map<String, dynamic>> jobHistory = [];

  List<VendorHistoryListData> historyServices = [];

  JobHistoryNotifier() {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await fetchHistoryList();
    await loadJobHistory();
  }

  Future<void> fetchHistoryList() async {
    try {
      final response = await VendorJobsRepository.instance.apiVendorHistoryList(VendorIdRequest(vendorId: userData?.customerId ?? 0));
      if (response is VendorHistoryListResponse && response.success == true) {
        historyServices = response.data ?? [];

        print("historyServices");
        print(historyServices);
      } else {
        historyServices = [];
      }
    } catch (e, stack) {
      print("Error fetching customer History jobs: $e");
      print("Error fetching customer History jobs: $stack");
      historyServices = [];
    }
    notifyListeners();
  }

  Future<void> loadJobHistory() async {
    // Simulate API
    jobHistory = [
      {
        "id": 1,
        "customerName": "Ahmed Al Mazroui",
        "service": "Painting",
        "location": "Jumeirah, Villa 23",
        "date": "3 July 2025",
        "amount": 1250.00,
      },
      {
        "id": 2,
        "customerName": "Fatima Khan",
        "service": "Plumbing",
        "location": "Dubai Marina",
        "date": "5 July 2025",
        "amount": 800.00,
      },
    ];
     notifyListeners();
  }
}
