import 'dart:async';

import 'package:community_app/core/generated_locales/l10n.dart';
import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/modules/auth/login/login_screen.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_screen.dart';
import 'package:community_app/modules/customer/bottom_bar/bottom_screen.dart';
import 'package:community_app/modules/vendor/bottom_bar/bottom_bar_screen.dart';
import 'package:community_app/modules/vendor/onboard/vendor_onboard_screen.dart';
import 'package:community_app/res/themes.dart';
import 'package:community_app/utils/crashlytics_service.dart';
import 'package:community_app/utils/helpers/app_initializer.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  await CrashlyticsService.runWithCrashlytics(() async {
    await AppInitializer.initialize();

    final userData = await AppInitializer.loadUserData();

    runApp(MyApp(
      token: userData["token"],
      user: userData["user"],
      isOptionSelectionCompleted: userData["optionSelectionCompleted"],
    ));
  });
}

class MyApp extends StatelessWidget {
  final String? token;
  final LoginResponse? user;
  final bool? isOptionSelectionCompleted;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({
    super.key,
    required this.token,
    required this.user,
    required this.isOptionSelectionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      user: user,
      isOptionSelectionCompleted: isOptionSelectionCompleted,
    );
  }
}

class AppWrapper extends StatelessWidget {
  final LoginResponse? user;
  final bool? isOptionSelectionCompleted;

  const AppWrapper({super.key, this.user, this.isOptionSelectionCompleted});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageNotifier>(
          create: (_) => LanguageNotifier(),
        ),
        // Add other global providers here if needed
      ],
      child: Builder(
        builder: (context) {
          final langNotifier = context.watch<LanguageNotifier>();
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            child: ToastificationWrapper(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: MyApp.navigatorKey,
                title: 'X10 solutions',
                locale: langNotifier.locale,
                supportedLocales: const [
                  Locale('en'),
                  Locale('ar'),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                onGenerateRoute: AppRouter.onGenerateRoute,
                home: _getInitialScreen(user, isOptionSelectionCompleted),
                theme: AppThemes.lightTheme(
                  languageCode: langNotifier.locale.languageCode,
                ),
                builder: (context, child) {
                  ScreenSize.init(context);

                  final mediaQueryData = MediaQuery.of(context);
                  final pixelRatio = mediaQueryData.devicePixelRatio;
                  final textScale = pixelRatio > 3.0 ? 0.8 : 1.0;

                  return MediaQuery(
                    data: mediaQueryData.copyWith(textScaleFactor: textScale),
                    child: child!,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getInitialScreen(LoginResponse? user, bool? isOptionSelectionCompleted) {
    if (user != null) {
      return user.type == "V" ?
      ((user.isOnboarded ?? false) ? VendorBottomScreen() : VendorOnboardScreen()) :
      CustomerBottomScreen();
    } else {
      return isOptionSelectionCompleted == true
          ? const LoginScreen()
          : const UserRoleSelectionScreen();
    }
  }
}
