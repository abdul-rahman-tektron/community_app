import 'dart:ui';
import 'package:community_app/modules/customer/registration/registration_address.dart';
import 'package:community_app/modules/customer/registration/registration_personal.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'registration_notifier.dart'; // Your notifier file

class CustomerRegistrationHandler extends StatelessWidget {
  const CustomerRegistrationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomerRegistrationNotifier(),
      child: Navigator(
        onGenerateRoute: (settings) {
          Widget screen;

          switch (settings.name) {
            case AppRoutes.customerRegistrationPersonal:
              screen = CustomerRegistrationPersonalScreen();
              break;
            case AppRoutes.customerRegistrationAddress:
              screen = CustomerRegistrationAddressScreen();
              break;
            default:
              screen = CustomerRegistrationPersonalScreen();
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
      filter: ImageFilter.blur(
        sigmaX: (1 - animation.value) * 5,
        sigmaY: (1 - animation.value) * 5,
      ),
      child: child,
    ),
  );
}
