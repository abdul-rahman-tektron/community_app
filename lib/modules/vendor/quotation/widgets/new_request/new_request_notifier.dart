import 'package:community_app/core/base/base_notifier.dart';


enum RequestCategory { plumbing, acRepair, electrical, cleaning, general }
enum RequestPriority { low, medium, high }

class NewRequestModel {
  final String id;
  final String customerName;
  final RequestCategory category;
  final String remarks;
  final DateTime dateTime;
  final String? location;
  final RequestPriority priority;
  final List<String>? attachments;

  NewRequestModel({
    required this.id,
    required this.customerName,
    required this.category,
    required this.remarks,
    required this.dateTime,
    this.location,
    this.priority = RequestPriority.medium,
    this.attachments,
  });

  bool get isNew {
    return DateTime.now().difference(dateTime).inDays <= 3;
  }
}


class NewRequestNotifier extends BaseChangeNotifier {
  List<NewRequestModel> requests = [
    NewRequestModel(
      id: 'REQ1001',
      customerName: 'Ali Hassan',
      category: RequestCategory.plumbing,
      remarks: 'Leakage in bathroom sink',
      dateTime: DateTime.now().subtract(Duration(days: 1)),
      location: 'Tower B, Flat 402',
      priority: RequestPriority.high,
      attachments: ['leak.jpg'],
    ),
    NewRequestModel(
      id: 'REQ1002',
      customerName: 'Sara Ahmed',
      category: RequestCategory.acRepair,
      remarks: 'AC not cooling',
      dateTime: DateTime.now().subtract(Duration(days: 4)), // Won't show "new" badge
      location: 'Villa 21, Community X',
      priority: RequestPriority.medium,
    ),
    NewRequestModel(
      id: 'REQ1003',
      customerName: 'Mohammed Yusuf',
      category: RequestCategory.electrical,
      remarks: 'Short circuit in kitchen',
      dateTime: DateTime.now().subtract(Duration(hours: 5)),
      location: 'Tower A, Apt 908',
      priority: RequestPriority.high,
      attachments: ['circuit.jpg', 'burn-mark.png'],
    ),
  ];
}
