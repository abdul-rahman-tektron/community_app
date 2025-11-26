import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:Xception/core/model/vendor/jobs/vendor_history_detail_request.dart';
import 'package:Xception/core/model/vendor/jobs/vendor_history_detail_response.dart';
import 'package:Xception/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:Xception/core/remote/services/vendor/vendor_jobs_repository.dart';
import 'dart:io';

import 'package:Xception/res/images.dart';
import 'package:flutter/material.dart';

class JobHistoryDetailNotifier extends BaseChangeNotifier {

  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();

  VendorHistoryDetailData? vendorHistoryDetailData;

  final int jobId;
  JobHistoryDetailNotifier(this.jobId) {
    runWithLoadingVoid(() => initializeData());
  }

  initializeData() async {
    await loadUserData();
    await Future.wait([apiJobInfoDetail(), fetchVendorHistoryDetail()]);
  }

  Future<void> apiJobInfoDetail() async {
    try {
      final result = await VendorDashboardRepository.instance.apiJobInfoDetail(jobId.toString() ?? "0");

      if (result is JobInfoDetailResponse) {
        jobDetail = result;
      } else {
        debugPrint("Unexpected result type from apiJobInfoDetail");
      }
    } catch (e) {
      debugPrint("Error in apiJobInfoDetail: $e");
    }
  }

  Future<void> fetchVendorHistoryDetail() async {
    try {
      isLoading = true;

      final response = await VendorJobsRepository.instance
          .apiVendorHistoryDetails(
        VendorHistoryDetailRequest(vendorId: userData?.customerId ?? 0, jobId: jobId ?? 0,),);
      if (response is VendorHistoryDetailResponse && response.success == true) {
        vendorHistoryDetailData = response.data;
        notifyListeners();
      } else {
        vendorHistoryDetailData = null;
      }
    } catch (e) {
      print("Error fetching vendor history jobs: $e");
      vendorHistoryDetailData = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  JobInfoDetailResponse get jobDetail => _jobDetail;
  set jobDetail(JobInfoDetailResponse value) {
    if (_jobDetail == value) return;
    _jobDetail = value;
    notifyListeners();
  }
}


class ImagePair {
  final String before;
  final String after;
  final bool isVideo;

  ImagePair({
    required this.before,
    required this.after,
    this.isVideo = false,
  });
}