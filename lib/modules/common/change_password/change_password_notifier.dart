import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/common/error/error_response.dart';
import 'package:Xception/core/model/common/password/change_password_request.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordNotifier extends BaseChangeNotifier {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  ChangePasswordNotifier(BuildContext context) {
    newPasswordController.addListener(() {
      notifyListeners(); // Notifies UI of password change
    });

    getUserData();
  }

  getUserData() async {
    await loadUserData();

    userIdController.text = userData?.userId ?? '';
  }

  void saveButtonFunctionality(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      runWithLoadingVoid(() => apiChangePassword(context));
    }
  }

  Future<void> apiChangePassword(BuildContext context) async {
    try {
      final parsed = await CommonRepository.instance.apiChangePassword(
        ChangePasswordRequest(
          userId: userIdController.text,
          oldPassword: currentPasswordController.text,
          newPassword: newPasswordController.text,
          confirmPassword: confirmPasswordController.text,
        )
      );
      // Optionally notify success here, or handle response

      print("parsed.runtimeType");
      print(parsed.runtimeType);

      if(parsed is CommonResponse && parsed.success == true) {
        ToastHelper.showSuccess("Password changed successfully");
        Navigator.pop(context);
      } else if(parsed is CommonResponse && parsed.success == false) {
        ToastHelper.showError(parsed.message ?? "Failed to change password");
      }
    } catch (e) {
      // Handle errors here, e.g., show Toast or dialog
      debugPrint('Error changing password: $e');
    }
  }

  @override
  void dispose() {
    userIdController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
