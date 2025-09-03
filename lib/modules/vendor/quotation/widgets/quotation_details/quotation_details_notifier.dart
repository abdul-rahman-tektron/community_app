import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_response_detail_response.dart';
import 'package:community_app/core/remote/services/vendor/vendor_dashboard_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/enums.dart' show QuotationStatus;

class QuotationDetailsNotifier extends BaseChangeNotifier {
  int? jobId;
  int? quotationResponseId;


  JobInfoDetailResponse _jobDetail = JobInfoDetailResponse();
  QuotationResponseDetailResponse _quotationDetail = QuotationResponseDetailResponse();

  QuotationDetailsNotifier(this.jobId, this.quotationResponseId) {
    runWithLoadingVoid(() => initializeData());
  }

  Future<void> initializeData() async {
    Future.wait([apiJobInfoDetail(), apiQuotationResponseDetail()]);
  }

  Future<void> apiJobInfoDetail() async {
    try {
      final result = await VendorDashboardRepository.instance.apiJobInfoDetail(jobId?.toString() ?? "0");

      if (result is JobInfoDetailResponse) {
        jobDetail = result;
      } else {
        debugPrint("Unexpected result type from apiJobInfoDetail");
      }
    } catch (e) {
      debugPrint("Error in apiJobInfoDetail: $e");
    }
  }

  Future<void> apiQuotationResponseDetail() async {
    try {
      final result = await VendorQuotationRepository.instance.apiQuotationDetail(quotationResponseId?.toString() ?? "0");

      if (result is QuotationResponseDetailResponse) {
        quotationDetail = result;

        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiQuotationResponseDetail");
      }
    } catch (e) {
      debugPrint("Error in apiQuotationResponseDetail: $e");
    }
  }

  QuotationStatus status = QuotationStatus.rejected;

  /// Direct access to the items list from the quotation detail
  List<QuotationResponseDetailResponseItem>? get items => quotationDetail.items;

  /// Calculate subtotal from all items (quantity * price or price if quantity is zero)
  double get subTotal {
    if (items == null) return 0;
    return items!.fold(0, (sum, item) {
      final qty = item.quantity ?? 0;
      final price = (item.price ?? 0).toDouble();
      return sum + (qty == 0 ? price : qty * price);
    });
  }

  double get vat => subTotal * 0.05;
  double get grandTotal => subTotal + vat;

  bool get isRejected => status == QuotationStatus.rejected;

  void resendQuotation() {
    print("Resending quotation...");
  }

  QuotationResponseDetailResponse get quotationDetail => _quotationDetail;
  set quotationDetail(QuotationResponseDetailResponse value) {
    if (_quotationDetail == value) return;
    _quotationDetail = value;
    notifyListeners();
  }

  JobInfoDetailResponse get jobDetail => _jobDetail;
  set jobDetail(JobInfoDetailResponse value) {
    if (_jobDetail == value) return;
    _jobDetail = value;
    notifyListeners();
  }
}
