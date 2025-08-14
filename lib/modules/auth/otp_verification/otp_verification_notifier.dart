import 'dart:async';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/password/verify_otp_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

class OtpVerificationNotifier extends BaseChangeNotifier {
  final int otpLength = 6;

  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;

  bool isResendEnabled = false;
  int secondsRemaining = 30;
  Timer? _timer;

  String? email;

  OtpVerificationNotifier(this.email) {
    _initOtpFields();
    _startResendCountdown();
  }

  void _initOtpFields() {
    otpControllers = List.generate(
      otpLength,
      (index) => TextEditingController(),
    );
    focusNodes = List.generate(otpLength, (index) => FocusNode());
  }

  void onOtpChange(String value, int index) {
    if (value.isNotEmpty && index < otpLength - 1) {
      // Move to next field
      FocusScope.of(
        focusNodes[index].context!,
      ).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move back if deleted
      FocusScope.of(
        focusNodes[index].context!,
      ).requestFocus(focusNodes[index - 1]);
    }
  }

  String get enteredOtp {
    return otpControllers.map((c) => c.text).join();
  }

  void verifyOtp(BuildContext context) {
    final otp = enteredOtp;
    if (otp.length != otpLength) {
      // Show error or validation
      ToastHelper.showError("Please enter the complete OTP");
      return;
    }
    // TODO: Call your API here
    print("Verifying OTP: $otp");

    apiVerifyOTP(context, email ?? "", otp);
  }

  Future<void> apiVerifyOTP(
    BuildContext context,
    String email,
    String otp,
  ) async {
    try {
      final parsed = await CommonRepository.instance
          .apiVerifyOTP(VerifyOtpRequest(email: email, otp: otp));

      if(parsed == true) {
        ToastHelper.showSuccess("OTP verified  successfully");
        Navigator.pushNamed(
          context,
          AppRoutes.resetPassword,
          arguments: {"email" : email, "otp" : otp},
        );
      } else {
        ToastHelper.showError("Failed to verify OTP");
      }
      // Optionally notify success here, or handle response
    } catch (e) {
      // Handle errors here, e.g., show Toast or dialog
      debugPrint('Error changing password: $e');
    }
  }

  void resendOtp() {
    // TODO: Call resend OTP API
    print("Resending OTP...");
    secondsRemaining = 30;
    isResendEnabled = false;
    notifyListeners();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        notifyListeners();
      } else {
        isResendEnabled = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}
