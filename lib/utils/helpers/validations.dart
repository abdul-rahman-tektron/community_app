import 'package:flutter/material.dart';
import 'package:community_app/utils/regex.dart';
import 'package:community_app/utils/extensions.dart'; // Assuming you have a context.locale extension or similar

class Validations {
  Validations._();

  static String? requiredField(BuildContext context, String? value, {String? customMessage}) {
    if (value == null || value.trim().isEmpty) {
      return customMessage ?? context.locale.requiredField;
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.locale.emailRequired;
    }
    if (!RegExp(RegexPatterns.email).hasMatch(value.trim())) {
      return context.locale.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.locale.passwordRequired;
    }
    if (value.trim().length < 6) {
      return context.locale.passwordTooShort;
    }
    return null;
  }

  static String? validateMobile(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.locale.mobileRequired;
    }
    if (!RegExp(RegexPatterns.phone).hasMatch(value.trim())) {
      return context.locale.invalidMobile;
    }
    return null;
  }

  static String? validateName(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.locale.fullName;
    }
    return null;
  }
}
