import 'dart:async';
import 'package:community_app/core/generated_locales/l10n.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/modules/auth/login/login_screen.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_screen.dart';
import 'package:community_app/modules/customer/bottom_bar/bottom_screen.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/themes.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/permissions_handler.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Request permissions
    await AppPermissionHandler.checkAndRequestLocation();

    await Hive.initFlutter();
    await HiveStorageService.init();

    // Lock orientation2
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.backgroundSecondary,
      statusBarIconBrightness: Brightness.dark,  // Android
      statusBarBrightness: Brightness.light,     // iOS
    ));

    // Initialize secure storage
    await SecureStorageService.init();

    final token = await SecureStorageService.getToken();

    runApp(MyApp(token: token,));
  }, (error, stackTrace) {
    // TODO: integrate error reporting (e.g., Crashlytics)
    debugPrint('Unhandled error: $error');
    debugPrint('$stackTrace');
  });
}

class MyApp extends StatelessWidget {
  final String? token;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageNotifier>(
          create: (_) => LanguageNotifier(),
        ),
        // Add other notifiers if needed
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
                navigatorKey: navigatorKey,
                title: 'Community App',
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
                home: token != null ?  CustomerBottomScreen() : const UserRoleSelectionScreen(),
                theme: AppThemes.lightTheme(languageCode: langNotifier.locale.languageCode),
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
                // Optionally set home, or let routes handle it
                // home: token != null ? BottomBarScreen() : const LoginScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
