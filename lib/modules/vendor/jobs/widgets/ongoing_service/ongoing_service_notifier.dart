import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';

import 'package:Xception/core/remote/services/vendor/vendor_jobs_repository.dart';

class OngoingServiceNotifier extends BaseChangeNotifier {
  List<OngoingJobsAssignedData> _ongoingJobs = [];

  List<OngoingJobsAssignedData> get ongoingJobs => _ongoingJobs;

  OngoingServiceNotifier() {
    initializeData();
  }

  Future initializeData() async {
    await loadUserData();
    await fetchOngoingJobs(userData?.customerId ?? 0);
  }

  Future<void> fetchOngoingJobs(int vendorId) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await VendorJobsRepository.instance.apiGetVendorOngoingJobs(vendorId.toString());
      if (response is OnGoingJobAssignedResponse && response.success == true) {
        _ongoingJobs = response.data ?? [];
      } else {
        _ongoingJobs = [];
      }
    } catch (e) {
      _ongoingJobs = [];
      print("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
