import 'package:community_app/core/generated_locales/l10n.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/themes.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/permissions_handler.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await AppPermissionHandler.checkAndRequestLocation();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppColors.backgroundSecondary,
    statusBarIconBrightness: Brightness.dark, // Android
    statusBarBrightness: Brightness.light,    // iOS
  ));

  runApp(const ProviderScope(child: MyApp()));
}

final counterProvider = StateProvider<int>((ref) => 0);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  static const supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageState = ref.watch(languageNotifierProvider);
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,               // adapt text for smaller screens
      splitScreenMode: true,
      child: ToastificationWrapper(
        child: MaterialApp.router(
          title: 'Community App',
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: languageState.locale,
          supportedLocales: supportedLocales,
          theme: AppThemes.lightTheme(languageCode: ref.watch(languageNotifierProvider).locale.languageCode),
          builder: (context, child) {
            ScreenSize.init(context);
            return child!;
          },
        ),
      ),
    );
  }
}
