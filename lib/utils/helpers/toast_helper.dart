import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  ToastHelper._(); // Prevent instantiation

  static void showError(String message, {BuildContext? context}) {
    _show(
      message,
      type: ToastificationType.error,
      icon: const Icon(LucideIcons.xCircle, color: Colors.red),
      context: context,
    );
  }

  static void showSuccess(String message, {BuildContext? context}) {
    _show(
      message,
      type: ToastificationType.success,
      icon: const Icon(LucideIcons.checkCircle, color: Colors.green),
      context: context,
    );
  }

  static void showInfo(String message, {BuildContext? context}) {
    _show(
      message,
      type: ToastificationType.info,
      icon: const Icon(Icons.info, color: Colors.blue),
      context: context,
    );
  }

  static void showWarning(String message, {BuildContext? context}) {
    _show(
      message,
      type: ToastificationType.warning,
      icon: const Icon(Icons.warning, color: Colors.orange),
      context: context,
    );
  }

  static void _show(
      String message, {
        required ToastificationType type,
        required Widget icon,
        BuildContext? context,
        Color? backgroundColor,
        Duration duration = const Duration(milliseconds: 3000),
      }) {
    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flat,
      title: Text(
        message,
        maxLines: 10,
        overflow: TextOverflow.visible,
      ),
      autoCloseDuration: duration,
      alignment: Alignment.topRight,
      icon: icon,
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      showProgressBar: true,
    );
  }
}
