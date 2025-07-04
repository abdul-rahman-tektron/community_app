import 'dart:typed_data';
import 'dart:ui';
import 'package:community_app/core/notifier/auth_notifier.dart';
import 'package:community_app/modules/auth/login/login_screen.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_screen.dart';
import 'package:community_app/modules/common/error_screen.dart';
import 'package:community_app/modules/common/network_error_screen.dart';
import 'package:community_app/modules/common/select_location_map.dart';
import 'package:community_app/modules/customer/registration/registration_address.dart';
import 'package:community_app/modules/customer/registration/registration_personal.dart';
import 'package:community_app/modules/vendor/registration/registration_personal.dart';
import 'package:community_app/utils/router/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String login = '/login';
  static const String userRoleSelection = '/user-role-selection';
  static const String ownerTenantRegistrationPersonal = '/owner-tenant-registration-personal';
  static const String ownerTenantRegistrationAddress = '/owner-tenant-registration-address';
  static const String vendorRegistrationPersonal = '/vendor-registration-personal';
  static const String vendorRegistrationAddress = '/vendor-registration-address';
  static const String vendorRegistrationTrading = '/vendor-registration-trading';
  static const String mapLocation = '/map-location';
  static const String bottomBar = '/bottom-bar';
  static const String applyPass = '/apply-pass';
  static const String pdfViewer = '/pdf-viewer';
  static const String networkError = '/network-error';
  static const String notFound = '/not-found';
  static const String splash = '/splash'; // New splash screen route
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.userRoleSelection,
    // Always start at splash
    navigatorKey: navigatorKey,
    errorBuilder: (context, state) => const NotFoundScreen(),
    refreshListenable: GoRouterRefreshStream(ref.watch(authNotifierProvider.notifier).stream),
    routes: [
      GoRoute(
        path: AppRoutes.userRoleSelection,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const UserRoleSelectionScreen(),
          transitionsBuilder: defaultPageTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: defaultPageTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.ownerTenantRegistrationPersonal,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OwnerTenantRegistrationPersonalScreen(),
          transitionsBuilder: defaultPageTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.ownerTenantRegistrationAddress,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OwnerTenantRegistrationAddressScreen(),
          transitionsBuilder: defaultPageTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.vendorRegistrationPersonal,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const VendorRegistrationPersonalScreen(),
          transitionsBuilder: defaultPageTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.mapLocation,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: SelectLocationMap(),
          transitionsBuilder: defaultPageTransition,
        ),
      ),
      GoRoute(
        path: AppRoutes.networkError,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NetworkErrorScreen(),
          transitionsBuilder: defaultPageTransition,
        ),
      ),
    ],
    redirect: (context, state) {
      return null;
    },
  );
});

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
