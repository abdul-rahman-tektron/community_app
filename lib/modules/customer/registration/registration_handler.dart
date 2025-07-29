import 'dart:ui';

import 'package:community_app/modules/customer/registration/registration_address.dart';
import 'package:community_app/modules/customer/registration/registration_personal.dart';
import 'package:community_app/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_stepper_flutter/horizontal_stepper_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'registration_notifier.dart'; // Your notifier file

class CustomerRegistrationHandler extends StatelessWidget {
  const CustomerRegistrationHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomerRegistrationNotifier(),
      builder: (context, child) {
        final notifier = context.watch<CustomerRegistrationNotifier>();

        // Get current step (0-based)
        final step = notifier.currentStep;

        // Pick the screen widget based on step
        Widget screen;
        switch (step) {
          case 1:
            screen = CustomerRegistrationPersonalScreen();
            break;
          case 2:
            screen = CustomerRegistrationAddressScreen();
            break;
          default:
            screen = CustomerRegistrationPersonalScreen();
        }

        return SafeArea(
          child: Scaffold(
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  color: AppColors.backgroundSecondary,
                  height: 120,
                  child: FlutterHorizontalStepper(
                    steps: const ["Personal", "Address"],
                    radius: 50,
                    currentStep: step,
                    thickness: 3,
                    completeStepColor: Colors.green,
                    currentStepColor: AppColors.primary,
                    inActiveStepColor: AppColors.textSecondary,
                    onClick: (index) {
                      debugPrint('Stepper clicked index: $index');
                      final stepIndex = index + 1;
                      debugPrint('Converted to zero-based step: $stepIndex');
                      if (stepIndex > 0 && stepIndex <= notifier.totalSteps) {
                        notifier.updateStep(stepIndex);
                      } else {
                        debugPrint('Invalid step index clicked: $index');
                      }
                    },
                    child: [
                      Icon(LucideIcons.userRound, color: AppColors.white),
                      Icon(LucideIcons.mapPin, color: AppColors.white),
                    ],
                  ),
                ),
                Expanded(child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  child: screen,
                )),
              ],
            ),
          ),
        );
      },
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
