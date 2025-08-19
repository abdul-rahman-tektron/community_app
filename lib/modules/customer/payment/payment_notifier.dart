import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

class PaymentNotifier extends BaseChangeNotifier {
  bool isCardSelected = true;
  bool saveCard = false;

  int? jobId;

  PaymentNotifier(this.jobId) {}

  final promoCodeController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderNameController = TextEditingController();

  bool isTermsExpanded = false;

  void toggleTermsExpanded() {
    isTermsExpanded = !isTermsExpanded;
    notifyListeners();
  }

  void togglePaymentMethod(bool value) {
    isCardSelected = value;
    notifyListeners();
  }

  void toggleSaveCard() {
    saveCard = !saveCard;
    notifyListeners();
  }

  Future<void> apiUpdateJobStatus(BuildContext context, int? statusId) async {
    if (statusId == null) return;
    try {
      notifyListeners();
      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId, statusId: statusId),
      );

      if (parsed is CommonResponse && parsed.success == true) {
        ToastHelper.showSuccess("Status updated to: ${AppStatus.fromId(statusId ?? 0)?.name ?? ""}");
        Navigator.pushNamed(context, AppRoutes.feedback, arguments: jobId);
      }
    } catch (e) {
      ToastHelper.showError('Error updating status: $e');
    } finally {
      notifyListeners();
    }
  }
}
