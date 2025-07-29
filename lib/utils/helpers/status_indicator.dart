import 'package:community_app/res/fonts.dart';
import 'package:community_app/utils/enums.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final EmployeeStatus status;

  const StatusIndicator({super.key, required this.status});

  Color get statusColor {
    switch (status) {
      case EmployeeStatus.available:
        return Colors.green;
      case EmployeeStatus.busy:
        return Colors.orange;
      case EmployeeStatus.unavailable:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case EmployeeStatus.available:
        return "Available";
      case EmployeeStatus.busy:
        return "Busy";
      case EmployeeStatus.unavailable:
        return "Unavailable";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6),
        Text(statusText, style: AppFonts.text12.regular.grey.style),
      ],
    );
  }
}
