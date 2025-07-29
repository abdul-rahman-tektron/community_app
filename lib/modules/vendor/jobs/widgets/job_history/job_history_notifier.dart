import 'package:community_app/core/base/base_notifier.dart';

class JobHistoryNotifier extends BaseChangeNotifier {
  List<Map<String, dynamic>> jobHistory = [];

  JobHistoryNotifier() {
    loadJobHistory();
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
