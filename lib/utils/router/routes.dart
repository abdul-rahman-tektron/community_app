import 'dart:ui';
import 'package:community_app/modules/customer/registration/registration_handler.dart';
import 'package:community_app/modules/vendor/registration/registration_handler.dart';
import 'package:flutter/material.dart';
import 'package:community_app/modules/auth/login/login_screen.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_screen.dart';
import 'package:community_app/modules/common/error_screen.dart';
import 'package:community_app/modules/common/network_error_screen.dart';
import 'package:community_app/modules/common/location/location_screen.dart';
import 'package:community_app/modules/customer/bottom_bar/bottom_screen.dart';
import 'package:community_app/modules/customer/registration/registration_address.dart';
import 'package:community_app/modules/customer/registration/registration_personal.dart';
import 'package:community_app/modules/vendor/registration/registration_personal.dart';

class AppRoutes {
  static const String login = '/login';
  static const String userRoleSelection = '/user-role-selection';
  static const String customerRegistrationPersonal = '/customer-registration-personal';
  static const String customerRegistrationAddress = '/customer-registration-address';
  static const String customerRegistrationHandler = '/customer-registration-handler';
  static const String vendorRegistrationPersonal = '/vendor-registration-personal';
  static const String vendorRegistrationAddress = '/vendor-registration-address';
  static const String vendorRegistrationHandler = '/vendor-registration-handler';
  static const String vendorRegistrationTrading = '/vendor-registration-trading';
  static const String vendorRegistrationBank = '/vendor-registration-bank';
  static const String mapLocation = '/map-location';
  static const String customerBottomBar = '/customer-bottom-bar';
  static const String ownerTenantBottomBar = '/owner-tenant-bottom-bar';
  static const String applyPass = '/apply-pass';
  static const String pdfViewer = '/pdf-viewer';
  static const String networkError = '/network-error';
  static const String notFound = '/not-found';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget screen;
    switch (settings.name) {
      case AppRoutes.login:
        screen = const LoginScreen();
        break;
      case AppRoutes.userRoleSelection:
        screen = const UserRoleSelectionScreen();
        break;
      case AppRoutes.vendorRegistrationHandler:
        screen = const VendorRegistrationHandler();
        break;
      case AppRoutes.customerRegistrationHandler:
        screen = const CustomerRegistrationHandler();
        break;
      case AppRoutes.mapLocation:
        screen = SelectLocationMap();
        break;
      case AppRoutes.customerBottomBar:
        final currentIndex = settings.arguments as int;
        screen = CustomerBottomScreen(currentIndex: currentIndex,);
        break;
      case AppRoutes.networkError:
        screen = const NetworkErrorScreen();
        break;
      default:
        screen = const NotFoundScreen();
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: defaultPageTransition,
      transitionDuration: const Duration(milliseconds: 500),
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
