// To parse this JSON data, do
//
//     final customerOngoingJobsResponse = customerOngoingJobsResponseFromJson(jsonString);

import 'dart:convert';

CustomerOngoingJobsResponse customerOngoingJobsResponseFromJson(String str) => CustomerOngoingJobsResponse.fromJson(json.decode(str));

String customerOngoingJobsResponseToJson(CustomerOngoingJobsResponse data) => json.encode(data.toJson());

class CustomerOngoingJobsResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<CustomerOngoingJobsData>? data;

  CustomerOngoingJobsResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory CustomerOngoingJobsResponse.fromJson(Map<String, dynamic> json) => CustomerOngoingJobsResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<CustomerOngoingJobsData>.from(json["data"]!.map((x) => CustomerOngoingJobsData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CustomerOngoingJobsData {
  int? jobId;
  String? customerName;
  String? serviceName;
  DateTime? customerRequestedDate;
  double? estimatedAmount;
  String? jobStatusCategory;
  String? status;
  List<AssignedEmployee>? assignedEmployees;

  CustomerOngoingJobsData({
    this.jobId,
    this.customerName,
    this.serviceName,
    this.customerRequestedDate,
    this.estimatedAmount,
    this.jobStatusCategory,
    this.status,
    this.assignedEmployees,
  });

  factory CustomerOngoingJobsData.fromJson(Map<String, dynamic> json) => CustomerOngoingJobsData(
    jobId: json["jobId"],
    customerName: json["customerName"],
    serviceName: json["serviceName"],
    customerRequestedDate: json["customerRequestedDate"] == null ? null : DateTime.parse(json["customerRequestedDate"]),
    estimatedAmount: json["estimatedAmount"],
    jobStatusCategory: json["jobStatusCategory"],
    status: json["status"],
    assignedEmployees: json["assignedEmployees"] == null ? [] : List<AssignedEmployee>.from(json["assignedEmployees"]!.map((x) => AssignedEmployee.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "customerName": customerName,
    "serviceName": serviceName,
    "customerRequestedDate": customerRequestedDate?.toIso8601String(),
    "estimatedAmount": estimatedAmount,
    "jobStatusCategory": jobStatusCategory,
    "status": status,
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
