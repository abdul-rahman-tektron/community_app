// To parse this JSON data, do
//
//     final ongoingJobsResponse = ongoingJobsResponseFromJson(jsonString);

import 'dart:convert';

OngoingJobsResponse ongoingJobsResponseFromJson(String str) => OngoingJobsResponse.fromJson(json.decode(str));

String ongoingJobsResponseToJson(OngoingJobsResponse data) => json.encode(data.toJson());

class OngoingJobsResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<OngoingJobsData>? data;

  OngoingJobsResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory OngoingJobsResponse.fromJson(Map<String, dynamic> json) => OngoingJobsResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<OngoingJobsData>.from(json["data"]!.map((x) => OngoingJobsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OngoingJobsData {
  int? jobId;
  String? customerName;
  String? serviceName;
  DateTime? customerRequestedDate;
  int? estimatedAmount;
  String? jobStatusCategory;
  List<OngoingJobsAssignedEmployee>? assignedEmployees;

  OngoingJobsData({
    this.jobId,
    this.customerName,
    this.serviceName,
    this.customerRequestedDate,
    this.estimatedAmount,
    this.jobStatusCategory,
    this.assignedEmployees,
  });

  factory OngoingJobsData.fromJson(Map<String, dynamic> json) => OngoingJobsData(
    jobId: json["jobId"],
    customerName: json["customerName"],
    serviceName: json["serviceName"],
    customerRequestedDate: json["customerRequestedDate"] == null ? null : DateTime.parse(json["customerRequestedDate"]),
    estimatedAmount: json["estimatedAmount"],
    jobStatusCategory: json["jobStatusCategory"],
    assignedEmployees: json["assignedEmployees"] == null ? [] : List<OngoingJobsAssignedEmployee>.from(json["assignedEmployees"]!.map((x) => OngoingJobsAssignedEmployee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "customerName": customerName,
    "serviceName": serviceName,
    "customerRequestedDate": customerRequestedDate?.toIso8601String(),
    "estimatedAmount": estimatedAmount,
    "jobStatusCategory": jobStatusCategory,
    "assignedEmployees": assignedEmployees == null ? [] : List<dynamic>.from(assignedEmployees!.map((x) => x.toJson())),
  };
}

class OngoingJobsAssignedEmployee {
  String? employeeName;
  String? employeePhoneNumber;
  dynamic emiratesIdPhoto;
  dynamic emiratesIdNumber;

  OngoingJobsAssignedEmployee({
    this.employeeName,
    this.employeePhoneNumber,
    this.emiratesIdPhoto,
    this.emiratesIdNumber,
  });

  factory OngoingJobsAssignedEmployee.fromJson(Map<String, dynamic> json) => OngoingJobsAssignedEmployee(
    employeeName: json["employeeName"],
    employeePhoneNumber: json["employeePhoneNumber"],
    emiratesIdPhoto: json["emiratesIdPhoto"],
    emiratesIdNumber: json["emiratesIdNumber"],
  );

  Map<String, dynamic> toJson() => {
    "employeeName": employeeName,
    "employeePhoneNumber": employeePhoneNumber,
    "emiratesIdPhoto": emiratesIdPhoto,
    "emiratesIdNumber": emiratesIdNumber,
  };
}
