import 'dart:ui';
import 'package:community_app/modules/customer/feedback/feedback_screen.dart';
import 'package:community_app/modules/customer/job_verification/job_verification_screen.dart';
import 'package:community_app/modules/customer/payment/payment_screen.dart';
import 'package:community_app/modules/customer/service_details/service_details_screen.dart';
import 'package:community_app/modules/vendor/jobs/widgets/job_history_detail/job_history_detail_screen.dart';
import 'package:community_app/modules/vendor/jobs/widgets/ongoing_service/progress_update/progress_update_screen.dart';
import 'package:community_app/modules/vendor/quotation/widgets/quotation_details/quotation_details_screen.dart';
import 'package:flutter/material.dart';

// Auth
import 'package:community_app/modules/auth/login/login_screen.dart';
import 'package:community_app/modules/auth/user_role_selection/user_role_selection_screen.dart';

// Common
import 'package:community_app/modules/common/error_screen.dart';
import 'package:community_app/modules/common/network_error_screen.dart';
import 'package:community_app/modules/common/location/location_screen.dart';

// Customer
import 'package:community_app/modules/customer/bottom_bar/bottom_screen.dart';
import 'package:community_app/modules/customer/change_password/change_password_screen.dart';
import 'package:community_app/modules/customer/delete_account/delete_account_screen.dart';
import 'package:community_app/modules/customer/edit_profile/edit_profile_screen.dart';
import 'package:community_app/modules/customer/new_services/booking_complete.dart';
import 'package:community_app/modules/customer/new_services/new_service_confirmation.dart';
import 'package:community_app/modules/customer/new_services/new_services_screen.dart';
import 'package:community_app/modules/customer/quotation_list/quotation_list_screen.dart';
import 'package:community_app/modules/customer/registration/registration_handler.dart';
import 'package:community_app/modules/customer/saved_cards/saved_cards_screen.dart';
import 'package:community_app/modules/customer/settings/settings_screen.dart';
import 'package:community_app/modules/customer/top_vendors/top_vendors_screen.dart';
import 'package:community_app/modules/customer/tracking/tracking_screen.dart';

// Vendor
import 'package:community_app/modules/vendor/bottom_bar/bottom_bar_screen.dart';
import 'package:community_app/modules/vendor/quotation/quotation_screen.dart';
import 'package:community_app/modules/vendor/quotation/widgets/add_quotation/add_quotation_screen.dart';
import 'package:community_app/modules/vendor/registration/registration_handler.dart';

class AppRoutes {
  /// 🔐 Auth
  static const String login = '/login';
  static const String userRoleSelection = '/user-role-selection';

  /// 🌐 Common
  static const String mapLocation = '/map-location';
  static const String settings = '/settings';
  static const String changePassword = '/change-password';
  static const String deleteAccount = '/delete-account';
  static const String editProfile = '/edit-profile';
  static const String savedCards = '/saved-cards';

  /// 👤 Customer
  static const String customerRegistrationPersonal = '/customer-registration-personal';
  static const String customerRegistrationAddress = '/customer-registration-address';
  static const String customerRegistrationHandler = '/customer-registration-handler';
  static const String tracking = '/tracking';
  static const String customerBottomBar = '/customer-bottom-bar';
  static const String newServices = '/new_services';
  static const String newServicesConfirmation = '/new_services_confirmation';
  static const String topVendors = '/top_vendors';
  static const String quotationList = '/quotation_list';
  static const String bookingConfirmation = '/booking-confirmation';
  static const String jobVerification = '/job-verification';
  static const String payment = '/payment';
  static const String feedback = '/feedback';
  static const String serviceDetails = '/service-details';

  /// 🧑‍🔧 Vendor
  static const String vendorRegistrationPersonal = '/vendor-registration-personal';
  static const String vendorRegistrationAddress = '/vendor-registration-address';
  static const String vendorRegistrationHandler = '/vendor-registration-handler';
  static const String vendorRegistrationTrading = '/vendor-registration-trading';
  static const String vendorRegistrationBank = '/vendor-registration-bank';
  static const String vendorBottomBar = '/vendor-bottom-bar';
  static const String addQuotation = '/add-quotation';
  static const String jobHistoryDetail = '/job-history-detail';
  static const String quotationDetails = '/quotation-details';
  static const String progressUpdate = '/progress-update';

  /// ❗ Error
  static const String networkError = '/network-error';
  static const String notFound = '/not-found';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Widget screen;

    switch (settings.name) {
      // 🔐 Auth
      case AppRoutes.login:
        screen = const LoginScreen();
        break;
      case AppRoutes.userRoleSelection:
        screen = const UserRoleSelectionScreen();
        break;

      // 🧑‍🔧 Vendor
      case AppRoutes.vendorRegistrationHandler:
        screen = const VendorRegistrationHandler();
        break;
      case AppRoutes.vendorBottomBar:
        final currentIndex = settings.arguments as int;
        screen = VendorBottomScreen(currentIndex: currentIndex);
        break;
      case AppRoutes.addQuotation:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final jobId = args['jobId'] as int?;
        final serviceId = args['serviceId'] as int?;
        final quotationId = args['quotationId'] as int?;
        screen = AddQuotationScreen(
          jobId: jobId,
          serviceId: serviceId,
          quotationId: quotationId,
        );
        break;
      case AppRoutes.jobHistoryDetail:
        final jobId = settings.arguments as int;
        screen = JobHistoryDetailScreen(jobId: jobId);
        break;
      case AppRoutes.quotationDetails:
        screen = QuotationDetailScreen();
        break;
        case AppRoutes.progressUpdate:
        screen = ProgressUpdateScreen();
        break;

      // 👤 Customer
      case AppRoutes.customerRegistrationHandler:
        screen = CustomerRegistrationHandler();
        break;
      case AppRoutes.customerBottomBar:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final currentIndex = args['currentIndex'] as int? ?? 0;
        final category = args['category'] as String?;
        screen = CustomerBottomScreen(currentIndex: currentIndex, initialCategory: category);
        break;
      case AppRoutes.newServices:
        screen = NewServicesScreen();
        break;
      case AppRoutes.newServicesConfirmation:
        final serviceId = settings.arguments as String;
        screen = ServiceRequestConfirmationScreen(serviceId: serviceId);
        break;
      case AppRoutes.bookingConfirmation:
        final bookingId = settings.arguments as String;
        screen = BookingConfirmationScreen(bookingId: bookingId);
        break;
      case AppRoutes.tracking:
        screen = TrackingScreen();
        break;
      case AppRoutes.topVendors:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final jobId = args['jobId'] as int?;
        final serviceId = args['serviceId'] as int?;
        screen = TopVendorsScreen(jobId: jobId, serviceId: serviceId);
        break;
      case AppRoutes.quotationList:
        screen = QuotationListScreen();
        break;
      case AppRoutes.jobVerification:
        screen = JobVerificationScreen();
        break;
      case AppRoutes.payment:
        screen = PaymentScreen();
        break;
        case AppRoutes.feedback:
        screen = FeedbackScreen();
        break;
        case AppRoutes.serviceDetails:
        screen = ServiceDetailsScreen();
        break;

      // 🌐 Common
      case AppRoutes.mapLocation:
        screen = SelectLocationMap();
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

      // ❗ Error
      case AppRoutes.networkError:
        screen = const NetworkErrorScreen();
        break;

      // Default
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
