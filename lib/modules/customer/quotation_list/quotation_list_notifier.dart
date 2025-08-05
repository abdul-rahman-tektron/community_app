import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/create_job_booking_request.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:community_app/core/remote/services/customer/customer_dashboard_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

class QuotationListNotifier extends BaseChangeNotifier {
  final List<int> _selected = [];
  List<QuotationRequestListData> jobs = [];
  bool isLoading = true;

  int? jobId;

  QuotationListNotifier(this.jobId) {
    initializeData();
  }

  initializeData() async {
    await apiQuotationRequestList();
  }

  Future<void> apiQuotationRequestList() async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = await CustomerDashboardRepository.instance.apiQuotationList(jobId?.toString() ?? "0") as QuotationRequestListResponse;

      if (parsed.success == true && parsed.data != null) {
        jobs = parsed.data!;
      }
    } catch (e, stackTrace) {
      print("Error fetching quotation requests: $e");
      print("Stack: $stackTrace");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> apiJobBooking(BuildContext context, {
    required int jobId,
    required int quotationRequestId,
    required int quotationResponseId,
    required int vendorId,
    String? remarks,
  }) async {
    try {
      final request = CreateJobBookingRequest(
        jobId: jobId,
        quotationRequestId: quotationRequestId,
        quotationResponseId: quotationResponseId,
        vendorId: vendorId,
        remarks: remarks ?? "Accepted by customer",
        createdBy: "Customer", // or pass dynamically
      );

      final result = await CustomerDashboardRepository.instance.apiCreateJobBookingRequest(request);

      print("result");
      print(result);
      await _handleCreatedJobSuccess(result, jobId, context);
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedJobSuccess(Object? result,int? jobId, BuildContext context) async {
    if (result is CommonResponse) {
      // Navigate only after successful booking
      Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: jobId.toString());
    }
  }

  bool isSelected(int index) => _selected.contains(index);

  void toggle(int index) {
    if (_selected.contains(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    notifyListeners();
  }

  List<int> get selectedIndexes => _selected;
}
