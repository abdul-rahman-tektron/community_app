import 'dart:ui';
import 'package:community_app/modules/customer/change_password/change_password_screen.dart';
import 'package:community_app/modules/customer/delete_account/delete_account_screen.dart';
import 'package:community_app/modules/customer/edit_profile/edit_profile_screen.dart';
import 'package:community_app/modules/customer/new_services/booking_complete.dart';
import 'package:community_app/modules/customer/new_services/new_service_confirmation.dart';
import 'package:community_app/modules/customer/quotation_list/quotation_list_screen.dart';
import 'package:community_app/modules/customer/registration/registration_handler.dart';
import 'package:community_app/modules/customer/saved_cards/saved_cards_screen.dart';
import 'package:community_app/modules/customer/settings/settings_screen.dart';
import 'package:community_app/modules/customer/top_vendors/top_vendors_screen.dart';
import 'package:community_app/modules/customer/tracking/tracking_screen.dart';
import 'package:community_app/modules/vendor/bottom_bar/bottom_bar_screen.dart';
import 'package:community_app/modules/vendor/quotation/quotation_screen.dart';
import 'package:community_app/modules/vendor/registration/registration_handler.dart';
import 'package:flutter/material.dart';
import 'package:community_app/modules/auth/login/login_screen.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_screen.dart';
import 'package:community_app/modules/common/error_screen.dart';
import 'package:community_app/modules/common/network_error_screen.dart';
import 'package:community_app/modules/common/location/location_screen.dart';
import 'package:community_app/modules/customer/bottom_bar/bottom_screen.dart';

import '../../modules/customer/new_services/new_services_screen.dart';

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
  static const String tracking = '/tracking';
  static const String customerBottomBar = '/customer-bottom-bar';
  static const String vendorBottomBar = '/vendor-bottom-bar';
  static const String ownerTenantBottomBar = '/owner-tenant-bottom-bar';
  static const String newServices = '/new_services';
  static const String newServicesConfirmation = '/new_services_confirmation';
  static const String topVendors = '/top_vendors';
  static const String quotationList = '/quotation_list';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String deleteAccount = '/delete-account';
  static const String editProfile = '/edit-profile';
  static const String savedCards = '/saved-cards';
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
        screen = CustomerBottomScreen(currentIndex: currentIndex);
        break;
      case AppRoutes.vendorBottomBar:
        final currentIndex = settings.arguments as int;
        screen = VendorBottomScreen(currentIndex: currentIndex);
        break;
      case AppRoutes.newServices:
        screen = NewServicesScreen();
        break;

      case AppRoutes.newServicesConfirmation:
        final serviceId = settings.arguments as String;
        screen = ServiceRequestConfirmationScreen(serviceId: serviceId);
        break;
      case AppRoutes.tracking:
        screen = TrackingScreen();
        break;
        case AppRoutes.topVendors:
        screen = TopVendorsScreen();
        break;
      case AppRoutes.quotationList:
        screen = QuotationListScreen();
        break;

        case AppRoutes.bookingConfirmation:
          final bookingId = settings.arguments as String;
        screen = BookingConfirmationScreen(bookingId: bookingId);
        break;

        case AppRoutes.settings:
        screen = SettingsScreen();
        break;

        case AppRoutes.changePassword:
        screen = ChangePasswordScreen();
        break;

        case AppRoutes.deleteAccount:
        screen = DeleteAccountScreen();
        break;

        case AppRoutes.editProfile:
        screen = EditProfileScreen();
        break;
        case AppRoutes.savedCards:
        screen = SavedCardsScreen();
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
