import 'package:community_app/res/colors.dart';
import 'package:community_app/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomStepperItem {
  final String title;
  final IconData icon;

  CustomStepperItem({required this.title, required this.icon});
}

class CustomerStepper extends StatelessWidget {
  final int currentStep;
  final List<CustomStepperItem> steps;
  final Function(int) onStepTapped;
  final double stepSize;
  final double lineThickness;

  const CustomerStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    required this.onStepTapped,
    this.stepSize = 40,
    this.lineThickness = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundSecondary,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Stepper line + steps
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isEven) {
                final index = i ~/ 2;
                final isActive = index == currentStep;
                final isCompleted = index < currentStep;

                return Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => onStepTapped(index),
                    child: Column(
                      children: [
                        Container(
                          height: stepSize,
                          width: stepSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? AppColors.primary
                                : isCompleted
                                ? Colors.green
                                : Colors.grey.shade300,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            steps[index].icon,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                final isCompleted = i < currentStep * 2 - 1;
                return Expanded(
                  flex: 1,
                  child: Container(
                    height: lineThickness,
                    alignment: Alignment.center,
                    color: isCompleted ? AppColors.primary : Colors.grey.shade300,
                  ),
                );
              }
            }),
          ),

          const SizedBox(height: 8),

          /// Titles aligned under steps
          Row(
            children: List.generate(steps.length * 2 - 1, (i) {
              if (i.isEven) {
                final index = i ~/ 2;
                return Expanded(
                  flex: 2,
                  child: Text(
                    steps[index].title,
                    style: AppFonts.text12.regular.style,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              } else {
                return const Expanded(flex: 1, child: SizedBox());
              }
            }),
          ),
        ],
      ),
    );
  }
}

