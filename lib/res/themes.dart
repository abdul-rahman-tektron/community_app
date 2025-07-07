import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppThemes {
  AppThemes._();

  /// Builds theme data based on language code
  static ThemeData lightTheme({required String languageCode}) {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: languageCode == 'ar' ? AppFonts.arabicFont : AppFonts.primaryFont,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppColors.backgroundSecondary,
          statusBarIconBrightness: Brightness.dark, // Android
          statusBarBrightness: Brightness.light,    // iOS
        ),
        color: AppColors.backgroundSecondary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.textPrimary,
        selectionColor: AppColors.primary.withOpacity(0.4),
        selectionHandleColor: AppColors.textPrimary,
      ),
      useMaterial3: true,
      // Extend with more theme customizations if needed
    );
  }
}
