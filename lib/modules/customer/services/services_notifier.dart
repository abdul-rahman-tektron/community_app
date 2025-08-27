import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/user/customer_id_request.dart';
import 'package:community_app/core/model/customer/job/customer_history_list_response.dart';
import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';

import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';

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

  Technician({required this.name, this.contact, this.imageUrl});
}

class ProductUsed {
  final String name;
  final int quantity;

  ProductUsed({required this.name, required this.quantity});
}

class ServicesNotifier extends BaseChangeNotifier {
  int _selectedIndex = 0;

  /// Raw API model list - upcoming jobs as received from backend
  List<CustomerOngoingJobsData> upcomingServices = [];
  List<CustomerHistoryListData> historyServices = [];

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
      isLoading = true;
      await fetchCustomerOngoingJobs(userData!.customerId!);
      await fetchHistoryList();
      isLoading = false;
    }
  }

  /// Fetch ongoing jobs for the customer and store raw API model data
  Future<void> fetchCustomerOngoingJobs(int customerId) async {
    try {
      final response = await CustomerJobsRepository.instance.apiGetCustomerOngoingJobs(
        customerId.toString(),
      );
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

  Future<void> fetchHistoryList() async {
    try {
      final response = await CustomerJobsRepository.instance.apiCustomerHistoryList(
        CustomerIdRequest(customerId: userData?.customerId ?? 0),
      );
      if (response is CustomerHistoryListResponse && response.success == true) {
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
}
