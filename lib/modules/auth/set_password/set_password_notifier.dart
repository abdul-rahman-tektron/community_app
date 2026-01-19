import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/password/reset_password_request.dart';
import 'package:Xception/core/model/common/set_password/set_password_request.dart';
import 'package:Xception/core/model/common/set_password/set_password_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:Xception/utils/enums.dart';

class SetPasswordNotifier extends BaseChangeNotifier {
  String? email;
  String? otp;
  String? userId;

  SetPasswordNotifier(this.email, this.otp, this.userId) {
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
          .apiSetPassword(
        SetPasswordRequest(
          password: newPasswordController.text,
          userId: userId,
        ),
      );

      if(parsed is SetPasswordResponse) {
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
