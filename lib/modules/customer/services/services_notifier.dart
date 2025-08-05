
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';

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
  int _selectedIndex = 0;

  /// Raw API model list - upcoming jobs as received from backend
  List<CustomerOngoingJobsData> upcomingServices = [];

  /// Keep static previous services for now, still using ServiceModel UI model
  List<ServiceModel> previousServices = [
    ServiceModel(
      id: '4789789',
      title: 'Service X',
      date: DateTime.now().subtract(const Duration(days: 10)),
      progressStatus: 'Completed',
      productUsed: [
        ProductUsed(name: 'Screwdriver Set', quantity: 1),
        ProductUsed(name: 'Wiring Kit', quantity: 2),
      ],
    ),
    ServiceModel(
      id: '5567567',
      title: 'Service Y',
      date: DateTime.now().subtract(const Duration(days: 15)),
      progressStatus: 'Resolved with Maintenance',
      productUsed: [
        ProductUsed(name: 'Sealant', quantity: 1),
      ],
    ),
  ];

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    if (_selectedIndex == value) return;
    _selectedIndex = value;
    notifyListeners();
  }

  ServicesNotifier() {
    initializeData();
  }

  Future<void> initializeData() async {
    await loadUserData();
    if (userData?.customerId != null) {
      await fetchCustomerOngoingJobs(userData!.customerId!);
    }
  }

  /// Fetch ongoing jobs for the customer and store raw API model data
  Future<void> fetchCustomerOngoingJobs(int customerId) async {
    try {
      final response = await CustomerJobsRepository.instance.apiGetCustomerOngoingJobs(customerId.toString());
      if (response is CustomerOngoingJobsResponse && response.success == true) {
        upcomingServices = response.data ?? [];

        print("upcomingServices");
        print(upcomingServices);
      } else {
        upcomingServices = [];
      }
    } catch (e) {
      print("Error fetching customer ongoing jobs: $e");
      upcomingServices = [];
    }
    notifyListeners();
  }

}



