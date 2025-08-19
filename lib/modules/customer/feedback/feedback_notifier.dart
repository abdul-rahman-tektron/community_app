import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/model/customer/job/update_customer_completion_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

class FeedbackNotifier extends ChangeNotifier {
  double vendorRating = 0;
  double serviceRating = 0;

  int? jobId;

  FeedbackNotifier(this.jobId) {}

  final TextEditingController vendorCommentController = TextEditingController();
  final TextEditingController serviceCommentController = TextEditingController();

  final emoticons = ['😫', '🙁', '😐', '🙂', '😄'];

  void updateVendorRating(double rating) {
    vendorRating = rating;
    notifyListeners();
  }

  void updateServiceRating(double rating) {
    serviceRating = rating;
    notifyListeners();
  }

  // Optionally, add submit methods
  void submitVendorFeedback() {
    final comment = vendorCommentController.text;
    final rating = vendorRating;
    // handle submission
  }

  void submitServiceFeedback() {
    final comment = serviceCommentController.text;
    final rating = serviceRating;
    // handle submission
  }

  Future<void> apiUpdateCustomerJobCompletion(BuildContext context, FeedbackNotifier notifier, int jobId, String createdBy) async {
    try {
      final request = UpdateCustomerCompletionRequest(
        jobId: jobId,
        notes: "${vendorCommentController.text}\n${serviceCommentController.text}",
        workDonePercentage: 100, // or make it dynamic if needed
        rating: ((vendorRating + serviceRating) / 2).round(), // average of both ratings
        feedback: "Vendor: ${vendorCommentController.text}\nService: ${serviceCommentController.text}",
        createdBy: createdBy,
      );

      final result = await CustomerJobsRepository.instance.apiUpdateCustomerCompletion(request);

      print("result");
      print(result);
      await _handleCreatedJobSuccess(result is CommonResponse, context, notifier);
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedJobSuccess(bool result, BuildContext context, FeedbackNotifier notifier) async {
    if (result) {
      ToastHelper.showSuccess("Feedback submitted successfully");
      notifier.apiUpdateJobStatus(context, AppStatus.jobClosedDone.id);
    } else {
      ToastHelper.showError("Failed to submit feedback. Please try again.");
    }
  }

  Future<void> apiUpdateJobStatus(BuildContext context, int? statusId) async {
    if (statusId == null) return;
    try {
      notifyListeners();
      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        ToastHelper.showSuccess("Status updated to: ${AppStatus.fromId(statusId)?.name ?? ""}");
        Navigator.pushNamed(context, AppRoutes.customerBottomBar);// or navigate to another screen
      }
    } catch (e) {
      ToastHelper.showError('Error updating status: $e');
    } finally {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    vendorCommentController.dispose();
    serviceCommentController.dispose();
    super.dispose();
  }
}
