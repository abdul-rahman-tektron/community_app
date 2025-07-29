import 'package:flutter/material.dart';

class OngoingServiceModel {
  final String customerName;
  final DateTime date;
  final String serviceName;
  final String jobId;
  final String progress;
  final String estimatedTime;
  final String assignedEmployee;
  final String? assignedEmployeeImage;
  final String location; // new field

  OngoingServiceModel({
    required this.customerName,
    required this.date,
    required this.serviceName,
    required this.jobId,
    required this.progress,
    required this.estimatedTime,
    required this.assignedEmployee,
    this.assignedEmployeeImage,
    required this.location, // add to constructor
  });
}

class OngoingServiceNotifier extends ChangeNotifier {
  final List<OngoingServiceModel> _ongoingJobs = [
    OngoingServiceModel(
      customerName: "Ahmed Al Mazroui",
      date: DateTime.now(),
      serviceName: "Painting",
      jobId: "JOB-20250716-01",
      progress: "On the Way",
      estimatedTime: "1:30 PM",
      assignedEmployee: "Ali Hassan",
      assignedEmployeeImage: "https://i.pravatar.cc/150?img=12",
      location: "Dubai Marina, Tower A",
    ),
    OngoingServiceModel(
      customerName: "Fatima Zahra",
      date: DateTime.now().subtract(Duration(days: 1)),
      serviceName: "AC Maintenance",
      jobId: "JOB-20250715-02",
      progress: "Started",
      estimatedTime: "2:45 PM",
      assignedEmployee: "Sara Khan",
      location: "Al Barsha South",
    ),
    OngoingServiceModel(
      customerName: "Omar Farooq",
      date: DateTime.now().subtract(Duration(days: 2)),
      serviceName: "Plumbing",
      jobId: "JOB-20250714-03",
      progress: "In Progress",
      estimatedTime: "4:00 PM",
      assignedEmployee: "Zaid Malik",
      assignedEmployeeImage: "https://i.pravatar.cc/150?img=5",
      location: "Jumeirah Beach Residence",
    ),
  ];

  List<OngoingServiceModel> get ongoingJobs => _ongoingJobs;
}

