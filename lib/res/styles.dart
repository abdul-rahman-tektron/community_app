import 'package:community_app/res/colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  static OutlineInputBorder fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.primary, width: 1),
  );

  static OutlineInputBorder enabledFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.secondary),
  );

  static OutlineInputBorder focusedFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.secondary),
  );

  static OutlineInputBorder errorFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.error),
  );
}