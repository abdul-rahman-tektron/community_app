import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/password/reset_password_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:community_app/utils/enums.dart';

class ResetPasswordNotifier extends BaseChangeNotifier {
  String? email;
  String? otp;

  ResetPasswordNotifier(this.email, this.otp) {
    newPasswordController.addListener(_onPasswordChanged);
  }

  final formKey = GlobalKey<FormState>();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _onPasswordChanged() {
    notifyListeners(); // Triggers rebuild for password strength widget
  }

  void savePassword(BuildContext ctx) {
    if (!formKey.currentState!.validate()) return;

    notifyListeners();

    // Simulate API call
    apiResetPassword(ctx, email ?? "");
  }

  Future<void> apiResetPassword(BuildContext context, String email) async {
    try {
      final parsed = await CommonRepository.instance
          .apiResetPassword(
            ResetPasswordRequest(
              email: email,
              otp: otp,
              newPassword: newPasswordController.text,
            ),
          );

      if(parsed == "Password reset successfully.") {
        ToastHelper.showSuccess("Password reset successfully.");
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      } else {
        ToastHelper.showError("Failed to reset password. Try again.");
      }
    } catch (e) {
      // Handle errors here, e.g., show Toast or dialog
      debugPrint('Error changing password: $e');
    }
  }

  @override
  void dispose() {
    newPasswordController.removeListener(_onPasswordChanged);
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
