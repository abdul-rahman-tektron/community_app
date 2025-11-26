import 'dart:ui';
import 'package:Xception/modules/vendor/registration/registration_address.dart';
import 'package:Xception/modules/vendor/registration/registration_bank.dart';
import 'package:Xception/modules/vendor/registration/registration_notifier.dart';
import 'package:Xception/modules/vendor/registration/registration_personal.dart';
import 'package:Xception/modules/vendor/registration/registration_trading.dart';
import 'package:Xception/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_stepper_flutter/horizontal_stepper_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class VendorRegistrationHandler extends StatelessWidget {
  const VendorRegistrationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorRegistrationNotifier(),
      builder: (context, child) {
        final notifier = context.watch<VendorRegistrationNotifier>();

        final step = notifier.currentStep;

        // Determine the screen based on step
        Widget screen;
        switch (step) {
          case 1:
            screen = VendorRegistrationPersonalScreen();
            break;
          case 2:
            screen = VendorRegistrationAddressScreen();
            break;
          case 3:
            screen = VendorRegistrationTradingScreen();
            break;
          case 4:
            screen = VendorRegistrationBankScreen();
            break;
          default:
            screen = VendorRegistrationPersonalScreen();
        }

        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  color: AppColors.backgroundSecondary,
                  height: 120,
                  child: FlutterHorizontalStepper(
                    steps: const ["Personal", "Address", "Trading", "Bank"],
                    radius: 50,
                    currentStep: step,
                    thickness: 3,
                    completeStepColor: Colors.green,
                    currentStepColor: AppColors.primary,
                    inActiveStepColor: AppColors.textSecondary,
                    onClick: (index) {
                      final stepIndex = index + 1;
                      if (stepIndex > 0 && stepIndex <= notifier.totalSteps) {
                        notifier.updateStep(stepIndex);
                      }
                    },
                    child: const [
                      Icon(LucideIcons.userRound, color: AppColors.white),
                      Icon(LucideIcons.mapPin, color: AppColors.white),
                      Icon(LucideIcons.building2, color: AppColors.white),
                      Icon(LucideIcons.banknote, color: AppColors.white),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                    child: screen,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Shared transition
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
