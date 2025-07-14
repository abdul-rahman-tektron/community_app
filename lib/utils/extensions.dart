import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/generated_locales/l10n.dart';
import 'package:community_app/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

extension LocalizationX on BuildContext {
  AppLocalizations get locale => AppLocalizations.of(this)!;
}

extension StringExtensions on String {
  bool isArabic() {
    final arabicRegExp = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegExp.hasMatch(this);
  }

  /// Parses a date string in `dd/MM/yyyy` format and returns a DateTime
  DateTime toDateTimeFromDdMmYyyy() {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(this.trim());
    } catch (e) {
      throw FormatException('Invalid date format: $this');
    }
  }

  /// Parses a date string in `dd/MM/yyyy hh:mm a` format and returns a DateTime
  DateTime toDateTimeFromDdMmYyyyHhMmA() {
    try {
      return DateFormat('dd/MM/yyyy hh:mm a').parseStrict(this.trim());
    } catch (e) {
      throw FormatException('Invalid date format: $this');
    }
  }

  /// Parses and converts to `yyyy-MM-dd` string
  String toIsoDateFromDdMmYyyy() {
    final date = toDateTimeFromDdMmYyyy();
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Parses and converts to full ISO string (with time)
  String toFullIsoStringFromDdMmYyyy() {
    final date = toDateTimeFromDdMmYyyy();
    return date.toUtc().toIso8601String();
  }

  UserRole toUserRole() {
    print("this");
    print(this);
    switch (toLowerCase()) {
      case 'tenant':
        return UserRole.tenant;
      case 'owner':
        return UserRole.owner;
      case 'vendor':
        return UserRole.vendor;
      default:
        return UserRole.tenant;
    }
  }
}

extension FileBase64Extension on File {
  /// Converts the file to a Base64 encoded string
  Future<String> toBase64() async {
    final bytes = await readAsBytes();
    return base64Encode(bytes);
  }
}

extension DateFormatExtension on DateTime {
  String formatDateTime({bool withTime = false}) {
    final pattern = withTime ? 'dd/MM/yyyy, hh:mm a' : 'dd/MM/yyyy';
    return DateFormat(pattern).format(this);
  }

  String formatDate() => DateFormat('dd MMM yyyy').format(this); // e.g. 08 Jul 2025
  String formatTime() => DateFormat('hh:mm a').format(this); // e.g. 03:45 PM
}

extension UpcomingServiceStatusExtension on UpcomingServiceStatus {
  String get displayName {
    switch (this) {
      case UpcomingServiceStatus.tracking:
        return "Tracking";
      case UpcomingServiceStatus.inProgress:
        return "In Progress";
      case UpcomingServiceStatus.completed:
        return "Completed";
    }
  }
}
