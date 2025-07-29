// To parse this JSON data, do
//
//     final onGoingJobAssignedResponse = onGoingJobAssignedResponseFromJson(jsonString);

import 'dart:convert';

OnGoingJobAssignedResponse onGoingJobAssignedResponseFromJson(String str) => OnGoingJobAssignedResponse.fromJson(json.decode(str));

String onGoingJobAssignedResponseToJson(OnGoingJobAssignedResponse data) => json.encode(data.toJson());

class OnGoingJobAssignedResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<OngoingJobsAssignedData>? data;

  OnGoingJobAssignedResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory OnGoingJobAssignedResponse.fromJson(Map<String, dynamic> json) => OnGoingJobAssignedResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<OngoingJobsAssignedData>.from(json["data"]!.map((x) => OngoingJobsAssignedData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class OngoingJobsAssignedData {
  int? jobId;
  String? customerName;
  String? serviceName;
  DateTime? customerRequestedDate;
  int? estimatedAmount;
  String? jobStatusCategory;
  List<AssignedEmployee>? assignedEmployees;

  OngoingJobsAssignedData({
    this.jobId,
    this.customerName,
    this.serviceName,
    this.customerRequestedDate,
    this.estimatedAmount,
    this.jobStatusCategory,
    this.assignedEmployees,
  });

  factory OngoingJobsAssignedData.fromJson(Map<String, dynamic> json) => OngoingJobsAssignedData(
    jobId: json["jobId"],
    customerName: json["customerName"],
    serviceName: json["serviceName"],
    customerRequestedDate: json["customerRequestedDate"] == null ? null : DateTime.parse(json["customerRequestedDate"]),
    estimatedAmount: json["estimatedAmount"],
    jobStatusCategory: json["jobStatusCategory"],
    assignedEmployees: json["assignedEmployees"] == null ? [] : List<AssignedEmployee>.from(json["assignedEmployees"]!.map((x) => AssignedEmployee.fromJson(x))),
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

class AssignedEmployee {
  String? employeeName;
  String? employeePhoneNumber;
  String? emiratesIdPhoto;
  dynamic emiratesIdNumber;

  AssignedEmployee({
    this.employeeName,
    this.employeePhoneNumber,
    this.emiratesIdPhoto,
    this.emiratesIdNumber,
  });

  factory AssignedEmployee.fromJson(Map<String, dynamic> json) => AssignedEmployee(
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
