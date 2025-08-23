import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:community_app/core/model/vendor/jobs/vendor_history_detail_request.dart';
import 'package:community_app/core/model/vendor/jobs/vendor_history_detail_response.dart';
import 'package:community_app/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_jobs_repository.dart';
import 'dart:io';

import 'package:community_app/res/images.dart';
import 'package:flutter/material.dart';

class JobHistoryDetailNotifier extends BaseChangeNotifier {
  String customerName = "";
  String serviceName = "";
  String phone = "";
  String location = "";
  String requestedDate = "";
  String priority = "";
  String jobDescription = "";
  double totalAmount = 0;
  List<ImagePair> imagePairs = [];
  String notes = "";

  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();

  VendorHistoryDetailData? vendorHistoryDetailData;

  final int jobId;
  JobHistoryDetailNotifier(this.jobId) {
    // loadJobDetail();
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await apiJobInfoDetail();
    await fetchVendorHistoryDetail();
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

  Future<void> loadJobDetail() async {
    // Simulated API delay

    customerName = "Ahmed Al Mazroui";
    serviceName = "Painting";
    phone = "05576263567";
    location = "Jumeirah, Villa 23";
    requestedDate = "3 July 2025";
    priority = "Emergency";
    jobDescription =
    "Repaint three bedrooms. Remove old wallpaper in one room. Surface prep & apply two coats of washable paint.";
    totalAmount = 1250.00;
    notes =
    "The painting was completed as requested. Applied 2 coats of paint and replaced damaged wallpaper.";
    imagePairs = [
      ImagePair(
        before:
        "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
      ImagePair(
        before:
        "https://d2v5dzhdg4zhx3.cloudfront.net/web-assets/images/storypages/primary/ProductShowcasesampleimages/JPEG/Product+Showcase-1.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
      ImagePair(
        before:
        "https://jureursicphotography.com/wp-content/uploads/2020/10/2020_02_21_Sephora-Favurite-Box5247.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
      ImagePair(
        before:
        "https://jureursicphotography.com/wp-content/uploads/2020/10/2020_02_21_Sephora-Favurite-Box5247.jpg",
        after:
        "https://www.seoclerk.com/pics/407226-2eWiCl1471372939.jpg",
      ),
    ];
    notifyListeners();
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