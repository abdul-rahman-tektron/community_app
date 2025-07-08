
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/utils/enums.dart';

class ServiceModel {
  final String id;
  final String title;
  final DateTime date;
  final UpcomingServiceStatus? status;

  // Optional fields for various service types
  final String? progressStatus;
  final double? progressPercent;
  final DateTime? estimatedArrival;

  // For previous services
  final List<ProductUsed>? productUsed;

  // New: Technician assigned
  final Technician? technician;

  ServiceModel({
    required this.id,
    required this.title,
    required this.date,
    this.status,
    this.progressStatus,
    this.progressPercent,
    this.estimatedArrival,
    this.productUsed,
    this.technician,
  });
}

class Technician {
  final String name;
  final String? contact;
  final String? imageUrl;

  Technician({
    required this.name,
    this.contact,
    this.imageUrl,
  });
}

class ProductUsed {
  final String name;
  final int quantity;

  ProductUsed({
    required this.name,
    required this.quantity,
  });
}

class ServicesNotifier extends BaseChangeNotifier {
  List<ServiceModel> upcomingServices = [
// Tracking (only needs progressPercent and estimatedArrival)
    ServiceModel(
      id: '13453453',
      title: 'Service A',
      date: DateTime.now().add(Duration(days: 2)),
      status: UpcomingServiceStatus.tracking,
      progressPercent: 15,
      estimatedArrival: DateTime.now().add(Duration(hours: 5)),
    ),

// In Progress (needs only progressStatus)
    ServiceModel(
      id: '6',
      title: 'AC Repair',
      date: DateTime.now(),
      status: UpcomingServiceStatus.inProgress,
      progressStatus: 'Technician On Site',
      progressPercent: 65,
      technician: Technician(
        name: 'Ahmed Ali',
        contact: '+971 55 123 4567',
        imageUrl: 'https://example.com/profile.jpg',
      ),
    ),

// Completed (needs progressStatus + progressPercent)
    ServiceModel(
      id: '32343570',
      title: 'Service C',
      date: DateTime.now(),
      status: UpcomingServiceStatus.completed,
      progressStatus: 'Completed',
      progressPercent: 85,
    ),
  ];

  List<ServiceModel> previousServices = [
    ServiceModel(
      id: '4789789',
      title: 'Service X',
      date: DateTime.now().subtract(Duration(days: 10)),
      progressStatus: 'Completed',
      productUsed: [
        ProductUsed(name: 'Screwdriver Set', quantity: 1),
        ProductUsed(name: 'Wiring Kit', quantity: 2),
      ],
    ),
    ServiceModel(
      id: '5567567',
      title: 'Service Y',
      date: DateTime.now().subtract(Duration(days: 15)),
      progressStatus: 'Resolved with Maintenance',
      productUsed: [
        ProductUsed(name: 'Sealant', quantity: 1),
      ],
    ),
  ];
}
