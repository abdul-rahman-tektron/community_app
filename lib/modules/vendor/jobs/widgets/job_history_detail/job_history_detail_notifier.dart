import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/customer/payment/payment_detail_request.dart';
import 'package:Xception/core/model/customer/payment/payment_detail_response.dart';
import 'package:Xception/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:Xception/core/model/vendor/jobs/vendor_history_detail_request.dart';
import 'package:Xception/core/model/vendor/jobs/vendor_history_detail_response.dart';
import 'package:Xception/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:Xception/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:Xception/core/remote/services/vendor/vendor_jobs_repository.dart';
import 'dart:io';

import 'package:Xception/res/images.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class JobHistoryDetailNotifier extends BaseChangeNotifier {

  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();

  VendorHistoryDetailData? vendorHistoryDetailData;

  PaymentDetailResponse paymentDetail = PaymentDetailResponse();


  final int jobId;
  JobHistoryDetailNotifier(this.jobId) {
    runWithLoadingVoid(() => initializeData());
  }

  initializeData() async {
    await loadUserData();
    await Future.wait([apiJobInfoDetail(), fetchVendorHistoryDetail(), apiPaymentDetails()]);
  }

  // Line math
  num _linePreVat(LineItem it) {
    final q = it.quantity ?? 0;
    if (q == 0) return it.rate ?? 0;                 // qty==0 → use rate
    if (it.amount != null) return it.amount!;        // prefer server amount
    return (it.rate ?? 0) * q;                       // fallback: rate * qty
  }

  num _lineVat(LineItem it) {
    final q = it.quantity ?? 0;
    print('Quantity: $q');

    if (q == 0) {
      final vat = it.rate ?? 0;
      print('Quantity is 0 → using rate as VAT: $vat');
      return vat * 0.05;
    }

    if (it.amount != null) {
      print('Amount is not null → using amount as VAT: ${it.amount}');
      return it.amount! * 0.05;
    }

    final rate = it.rate ?? 0;
    final vat = (rate * q) * 0.05;
    print('Calculated VAT → rate: $rate, quantity: $q, VAT: $vat');

    return vat;
  }

  num _subTotal(Iterable<LineItem> items) => items.fold<num>(0, (s, it) => s + _linePreVat(it));
  num _vatTotal(Iterable<LineItem> items) => items.fold<num>(0, (s, it) => s + _lineVat(it));
  num grandTotal(Iterable<LineItem> items) => _subTotal(items) + _vatTotal(items);


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

  Future<void> apiPaymentDetails() async {
    try {
      final result = await CustomerJobsRepository.instance.apiPaymentDetail(
          PaymentDetailRequest(vendorId: userData?.customerId ?? 0, jobId: jobId));

      if (result is PaymentDetailResponse) {
        paymentDetail = result;
      }
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
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