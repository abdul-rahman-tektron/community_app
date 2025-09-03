import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/create_job_booking_request.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/model/customer/quotation/customer_response_reject_response.dart';
import 'package:community_app/core/model/customer/quotation/customer_response_request.dart';
import 'package:community_app/core/model/customer/quotation/customer_response_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_response_detail_response.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_dashboard_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class QuotationListNotifier extends BaseChangeNotifier {
  final List<int> _selected = [];
  List<QuotationRequestListData> jobs = [];
  int? jobId;

  QuotationListNotifier(this.jobId) {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await apiQuotationRequestList();
  }

  Future<void> apiQuotationRequestList() async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed = await CustomerDashboardRepository.instance
          .apiQuotationList(jobId?.toString() ?? "0") as QuotationRequestListResponse;

      if (parsed.success == true && parsed.data != null) {
        jobs = parsed.data!;

        print("📦 Jobs Data:");
        for (var job in jobs) {
          print("🛠 Job ID: ${job.jobId}");
          print("📑 Quotations count: ${job.jobQuotationRequest?.length ?? 0}");

          final quotations = job.jobQuotationRequest ?? [];
          for (var q in quotations) {
            print("➡️ Quotation ID: ${q.quotationId}, Vendor ID: ${q.toVendorId}, Has Response: ${q.hasQuotationResponse}");
          }
        }
      }
    } catch (e, stackTrace) {
      print("❌ Error fetching quotation requests: $e");
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
      await apiUpdateJobStatus(AppStatus.quotationAccepted.id);
      Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: jobId.toString());
    }
  }

  Future<void> apiUpdateJobStatus(int? statusId) async {
    if (statusId == null) return;
    try {
      notifyListeners();

      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId, createdBy: userData?.name ?? "", vendorId: userData?.customerId ?? 0),
      );

    } catch (e, stackTrace) {
      print("❌ Error updating job status: $e");
      print("Stack: $stackTrace");
      // ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      notifyListeners();
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

  Future<void> acceptSiteVisit(BuildContext context, int siteVisitId, {String? vendorEmail}) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await CustomerJobsRepository.instance
          .apiSiteVisitCustomerResponse(
        CustomerResponseRequest(siteVisitId: siteVisitId, isAccepted: true, jobid: jobId),
      );

      if (response is CustomerResponse && response.emailPreview != null) {
        final emailData = response.emailPreview!;

        // Update job status
        await apiUpdateJobStatus(AppStatus.siteVisitAccepted.id);

        // Prepare dynamic email
        final email = Email(
          body: emailData.body ?? "",
          subject: emailData.subject ?? "Site Visit Accepted",
          recipients: emailData.to ?? [],
          cc: emailData.cc ?? [],
          isHTML: true,
        );

        try {
          await FlutterEmailSender.send(email);
          ToastHelper.showSuccess("Site visit accepted successfully");
        } catch (e) {
          print("Error launching email client: $e");
          ToastHelper.showError("No email client available on this device.");
        }

        // Pop the screen back
        Navigator.pop(context);
      } else {
        ToastHelper.showError("Failed to accept site visit.");
      }
    } catch (e, st) {
      print("Error accepting site visit: $e");
      print(st);
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Reject Site Visit
  Future<void> rejectSiteVisit(BuildContext context, int siteVisitId) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await CustomerJobsRepository.instance
          .apiSiteVisitCustomerResponse(
          CustomerResponseRequest(siteVisitId: siteVisitId, isAccepted: false, jobid: jobId));

      if (response is CustomerResponseRejectResponse) {
        ToastHelper.showSuccess("Site visit rejected successfully");
        await apiUpdateJobStatus(AppStatus.siteVisitRejected.id);

        // Pop the screen back
        Navigator.pop(context);
      } else {
        ToastHelper.showError("Failed to reject site visit.");
      }
    } catch (e) {
      print("Error rejecting site visit: $e");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<int> get selectedIndexes => _selected;
}
