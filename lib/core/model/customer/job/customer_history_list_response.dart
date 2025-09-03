// To parse this JSON data, do
//
//     final customerHistoryListResponse = customerHistoryListResponseFromJson(jsonString);

import 'dart:convert';

CustomerHistoryListResponse customerHistoryListResponseFromJson(String str) => CustomerHistoryListResponse.fromJson(json.decode(str));

String customerHistoryListResponseToJson(CustomerHistoryListResponse data) => json.encode(data.toJson());

class CustomerHistoryListResponse {
  bool? success;
  String? message;
  List<CustomerHistoryListData>? data;

  CustomerHistoryListResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CustomerHistoryListResponse.fromJson(Map<String, dynamic> json) => CustomerHistoryListResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<CustomerHistoryListData>.from(json["data"]!.map((x) => CustomerHistoryListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CustomerHistoryListData {
  int? jobId;
  DateTime? requestedDate;
  DateTime? completedDate;
  String? priority;
  String? vendorName;
  dynamic remarks;
  double? totalAmount;
  dynamic paymentMethod;
  String? assignedEmployee;
  dynamic employeePhoneNumber;
  dynamic rating;
  dynamic feedbackComments;
  String? serviceName;
  int? serviceId;
  int? vendorId;

  CustomerHistoryListData({
    this.jobId,
    this.requestedDate,
    this.completedDate,
    this.priority,
    this.vendorName,
    this.remarks,
    this.totalAmount,
    this.paymentMethod,
    this.assignedEmployee,
    this.employeePhoneNumber,
    this.rating,
    this.feedbackComments,
    this.serviceName,
    this.serviceId,
    this.vendorId,
  });

  factory CustomerHistoryListData.fromJson(Map<String, dynamic> json) => CustomerHistoryListData(
    jobId: json["jobId"],
    requestedDate: json["requestedDate"] == null ? null : DateTime.parse(json["requestedDate"]),
    completedDate: json["completedDate"] == null ? null : DateTime.parse(json["completedDate"]),
    priority: json["priority"],
    vendorName: json["vendorName"],
    remarks: json["remarks"],
    totalAmount: json["totalAmount"],
    paymentMethod: json["paymentMethod"],
    assignedEmployee: json["assignedEmployee"],
    employeePhoneNumber: json["employeePhoneNumber"],
    rating: json["rating"],
    feedbackComments: json["feedbackComments"],
    serviceName: json["serviceName"],
    serviceId: json["serviceId"],
    vendorId: json["vendorId"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "requestedDate": requestedDate?.toIso8601String(),
    "completedDate": completedDate?.toIso8601String(),
    "priority": priority,
    "vendorName": vendorName,
    "remarks": remarks,
    "totalAmount": totalAmount,
    "paymentMethod": paymentMethod,
    "assignedEmployee": assignedEmployee,
    "employeePhoneNumber": employeePhoneNumber,
    "rating": rating,
    "feedbackComments": feedbackComments,
    "serviceName": serviceName,
    "serviceId": serviceId,
    "vendorId": vendorId,
  };
}
