import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/customer/job/create_job_booking_request.dart';
import 'package:Xception/core/model/customer/job/create_job_booking_response.dart';
import 'package:Xception/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:Xception/core/model/customer/quotation/customer_response_reject_response.dart';
import 'package:Xception/core/model/customer/quotation/customer_response_request.dart';
import 'package:Xception/core/model/customer/quotation/customer_response_response.dart';
import 'package:Xception/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:Xception/core/model/vendor/quotation_request/quotation_response_detail_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_dashboard_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:Xception/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:Xception/utils/helpers/common_utils.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
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

  Future<void> apiJobBooking(
      BuildContext context, {
        required int jobId,
        required int quotationRequestId,
        required int quotationResponseId,
        required int vendorId,
        String? remarks,
        required String dateOfVisit, // yyyy-MM-dd
      }) async {
    try {
      final request = CreateJobBookingRequest(
        jobId: jobId,
        quotationRequestId: quotationRequestId,
        quotationResponseId: quotationResponseId,
        vendorId: vendorId,
        remarks: remarks ?? "Accepted by customer",
        createdBy: userData?.name ?? "Customer",
        dateOfVisit: dateOfVisit,

        // ⚠️ If your DB requires VisitorEmail (as the error showed), include it here:
        // visitorEmail: userData?.email,  // <- add this field in the request model if present
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

  Future<void> _handleCreatedJobSuccess(Object? result, int? jobId, BuildContext context) async {
    // Case 1: Booking returned email preview (like site-visit)
    if (result is JobBookingResponse && result.emailPreview != null) {
      final emailData = result.emailPreview!;
      final email = Email(
        body: emailData.body ?? "",
        subject: emailData.subject ?? "Job Booking Confirmation",
        recipients: emailData.to ?? const [],
        cc: emailData.cc ?? const [],
        isHTML: true,
      );

      try {
        await FlutterEmailSender.send(email);
        ToastHelper.showSuccess(result.message ?? "Booking created and email prepared.");
      } catch (e) {
        print("Error launching email client: $e");
        ToastHelper.showError("No email client available on this device.");
      }

      // Update status if you have a status for booking confirmation
      await apiUpdateJobStatus(AppStatus.quotationAccepted.id);

      // Navigate to success screen
      Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: jobId?.toString());
      return;
    }

    // Case 2: Generic common response
    if (result is CommonResponse) {
      if (result.success == true) {
        ToastHelper.showSuccess(result.message ?? "Booking created successfully.");
        await apiUpdateJobStatus(AppStatus.quotationAccepted.id);
        Navigator.pushNamed(context, AppRoutes.bookingConfirmation, arguments: jobId?.toString());
      } else {
        ToastHelper.showError(result.message ?? "Failed to create booking.");
      }
      return;
    }

    // Fallback
    ToastHelper.showError("Unexpected response from server.");
  }


  Future<void> apiUpdateJobStatus(int? statusId, {bool? isReject = false}) async {
    if (statusId == null) return;
    try {
      notifyListeners();

      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId, createdBy: userData?.name ?? "", vendorId: userData?.customerId ?? 0),
      );

      if(isReject ?? false) ToastHelper.showSuccess("Quotation Rejected successfully!");

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
