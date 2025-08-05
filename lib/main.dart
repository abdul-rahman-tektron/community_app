import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:community_app/core/generated_locales/l10n.dart';
import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/core/notifier/language_notifier.dart';
import 'package:community_app/firebase_options.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_screen.dart';
import 'package:community_app/modules/customer/bottom_bar/bottom_screen.dart';
import 'package:community_app/modules/vendor/bottom_bar/bottom_bar_screen.dart';
import 'package:community_app/res/colors.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/res/themes.dart';
import 'package:community_app/utils/crashlytics_service.dart';
import 'package:community_app/utils/helpers/screen_size.dart';
import 'package:community_app/utils/location_helper.dart';
import 'package:community_app/utils/notification_service.dart';
import 'package:community_app/utils/permissions_handler.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

import 'dart:ui' as ui;

Future<void> main() async {
  await CrashlyticsService.runWithCrashlytics(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Permissions
    await AppPermissionHandler.checkAndRequestLocation();

    // Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Init Notifications
    await NotificationService().init();
    NotificationService().setNavigatorKey(MyApp.navigatorKey);

    // Hive & Secure storage
    await Hive.initFlutter();
    await HiveStorageService.init();
    await SecureStorageService.init();

    await LocationHelper.initialize();

    // Orientation & System UI
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      statusBarColor: AppColors.primary,
      statusBarIconBrightness: Brightness.light,
    ));

    // Load user
    final token = await SecureStorageService.getToken();
    final userJson = HiveStorageService.getUserData();
    LoginResponse? user;
    if (userJson != null) user = loginResponseFromJson(userJson);

    // Init Crashlytics
    await CrashlyticsService.init();

    // Run the app
    runApp(MyApp(token: token, user: user));
  });
}


class MyApp extends StatelessWidget {
  final String? token;
  final LoginResponse? user;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key, required this.token, required this.user});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageNotifier>(
          create: (_) => LanguageNotifier(),
        ),
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
                home: user != null
                    ? (user!.type == "V" ? VendorBottomScreen() : CustomerBottomScreen())
                    : const UserRoleSelectionScreen(),
                theme: AppThemes.lightTheme(
                    languageCode: langNotifier.locale.languageCode),
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
}

class BookingImagePainter extends CustomPainter {
  final ui.Image backgroundImage;
  final String name;
  final String phone;

  BookingImagePainter({
    required this.backgroundImage,
    required this.name,
    required this.phone,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background image (fit to canvas)
    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(0, 0, size.width, size.height),
      image: backgroundImage,
      fit: BoxFit.cover,
    );

    // Draw text on top
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$name\n$phone',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    // Position text at (100, 150)
    textPainter.paint(canvas, Offset(160, 85));
  }

  @override
  bool shouldRepaint(covariant BookingImagePainter oldDelegate) {
    return oldDelegate.name != name || oldDelegate.phone != phone || oldDelegate.backgroundImage != backgroundImage;
  }
}

// Helper to load asset image as ui.Image
Future<ui.Image> loadUiImage(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  return frame.image;
}

class BookingScreen extends StatefulWidget {
  final String name;
  final String phone;

  const BookingScreen({required this.name, required this.phone, super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  ui.Image? _backgroundImage;
  final GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final img = await loadUiImage(AppImages.nameTag);
    setState(() {
      _backgroundImage = img;
    });
  }

  // Load image asset as ui.Image
  Future<ui.Image> loadUiImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  // Convert CustomPaint widget to PNG Uint8List
  Future<Uint8List?> _exportToImage() async {
    try {
      RenderRepaintBoundary boundary =
      _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Error exporting image: $e');
      return null;
    }
  }

  Future<void> _shareImage() async {
    final imageBytes = await _exportToImage();
    if (imageBytes == null) return;

    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/booking_image.png').create();
    await file.writeAsBytes(imageBytes);

    await Share.shareXFiles([XFile(file.path)], text: 'Booking Details');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details Image'),
      ),
      body: Center(
        child: _backgroundImage == null
            ? const CircularProgressIndicator()
            : RepaintBoundary(
          key: _globalKey,
          child: CustomPaint(
            size: Size(400, 300), // Fixed size or responsive as needed
            painter: BookingImagePainter(
              backgroundImage: _backgroundImage!,
              name: widget.name,
              phone: widget.phone,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shareImage,
        icon: const Icon(Icons.share),
        label: const Text('Share'),
      ),
    );
  }
}
