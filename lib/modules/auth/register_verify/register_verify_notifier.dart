import 'dart:async';
import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/password/send_otp_request.dart';
import 'package:Xception/core/model/common/password/verify_otp_request.dart';
import 'package:Xception/core/model/common/password/verify_otp_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:flutter/material.dart';

class RegisterVerifyNotifier extends BaseChangeNotifier {
  final int otpLength = 6;

  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;

  bool isResendEnabled = false;
  int secondsRemaining = 30;
  Timer? _timer;

  String? email;

  RegisterVerifyNotifier(this.email) {
    _initOtpFields(email ?? "");
    _startResendCountdown();
  }

  void _initOtpFields(String email) {
    apiSendOTP(email);
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

      if(parsed is VerifyOtpResponse && parsed.isValid == true) {
        ToastHelper.showSuccess("OTP verified  successfully");
        Navigator.pushNamed(
          context,
          AppRoutes.setPassword,
          arguments: {"email" : email, "otp" : otp, "userId" : parsed.userId},
        );
      } else {
        ToastHelper.showError("Incorrect OTP");
      }
      // Optionally notify success here, or handle response
    } catch (e) {
      // Handle errors here, e.g., show Toast or dialog
      debugPrint('Error changing password: $e');
    }
  }

  Future<void> apiSendOTP(
      String email,
      ) async {
    try {
      await CommonRepository.instance
          .apiSendOTP(SendOtpRequest(email: email));

      // Optionally notify success here, or handle response
    } catch (e) {
      // Handle errors here, e.g., show Toast or dialog
      debugPrint('Error changing password: $e');
    }
  }

  void resendOtp() {
    apiSendOTP(email ?? "");
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
