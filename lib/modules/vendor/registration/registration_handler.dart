import 'dart:ui';
import 'package:community_app/modules/vendor/registration/registration_address.dart';
import 'package:community_app/modules/vendor/registration/registration_bank.dart';
import 'package:community_app/modules/vendor/registration/registration_notifier.dart';
import 'package:community_app/modules/vendor/registration/registration_personal.dart';
import 'package:community_app/modules/vendor/registration/registration_trading.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorRegistrationHandler extends StatelessWidget {
  const VendorRegistrationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorRegistrationNotifier(),
      child: Navigator(
        onGenerateRoute: (settings) {
          Widget screen;

          switch (settings.name) {
            case AppRoutes.vendorRegistrationPersonal:
              screen = VendorRegistrationPersonalScreen();
              break;
            case AppRoutes.vendorRegistrationAddress:
              screen = VendorRegistrationAddressScreen();
              break;
            case AppRoutes.vendorRegistrationTrading:
              screen = VendorRegistrationTradingScreen();
              break;
            case AppRoutes.vendorRegistrationBank:
              screen = VendorRegistrationBankScreen();
              break;
            default:
              screen = VendorRegistrationPersonalScreen();
          }

          return PageRouteBuilder(
            pageBuilder: (ctx, anim, secAnim) => screen,
            transitionsBuilder: defaultPageTransition,
            transitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
    );
  }
}

Widget defaultPageTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: (1 - animation.value) * 5, sigmaY: (1 - animation.value) * 5),
      child: child,
    ),
  );
}
