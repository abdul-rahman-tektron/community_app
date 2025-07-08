import 'package:community_app/res/fonts.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TrackingStepsWidget extends StatelessWidget {
  final int currentStep; // 0 to 4

  const TrackingStepsWidget({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final List<TrackingStep> steps = [
      TrackingStep(title: 'Request Received', time: '08:00 AM'),
      TrackingStep(title: 'Request Approved', time: '08:05 AM'),
      TrackingStep(title: 'Assigned to Staff', time: '08:10 AM'),
      TrackingStep(title: 'Staff Notified', time: '08:15 AM'),
      TrackingStep(title: 'Staff Accepted', time: '08:20 AM'),
      TrackingStep(title: 'Staff on the Way', time: '08:30 AM'),
      TrackingStep(title: 'Arrived at Location', time: '08:50 AM'), // not yet
      TrackingStep(title: 'Service Started', time: '09:00 AM'),     // not yet
    ];

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        reverse: true,
        itemCount: steps.length,
        separatorBuilder: (_, __) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          final step = steps[index];
          final isCompleted = index < currentStep;

          return ListTile(
            contentPadding:  EdgeInsets.zero,
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? Color(0xffd9ebdb) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Icon(
                isCompleted ? LucideIcons.check : LucideIcons.clock,
                color: isCompleted ? Colors.green : Colors.grey,
                size: 18,
              ),
            ),
            title: Text(
              step.title,
              style: AppFonts.text16.regular.style,
            ),
            trailing: isCompleted
                ? Text(step.time ?? "", style: AppFonts.text14.regular.style,)
                : null,
          );
        },
      ),
    );
  }
}


class TrackingStep {
  final String title;
  final String? time; // nullable if not yet completed

  TrackingStep({required this.title, this.time});
}