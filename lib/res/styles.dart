import 'package:community_app/res/colors.dart';
import 'package:flutter/material.dart';

class AppStyles {
  AppStyles._();

  static OutlineInputBorder fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.textSecondary, width: 0.5),
  );

  static OutlineInputBorder enabledFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.textSecondary, width: 0.5),
  );

  static OutlineInputBorder focusedFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.textSecondary, width: 1),
  );

  static OutlineInputBorder errorFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.error),
  );
}