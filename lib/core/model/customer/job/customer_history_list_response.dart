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
  dynamic completedDate;
  String? priority;
  String? vendorName;
  dynamic remarks;
  double? totalAmount;
  dynamic paymentMethod;
  String? employeeName;
  dynamic employeePhoneNumber;
  int? rating;
  dynamic feedbackComments;
  dynamic beforePhotoUrl;
  dynamic afterPhotoUrl;

  CustomerHistoryListData({
    this.jobId,
    this.requestedDate,
    this.completedDate,
    this.priority,
    this.vendorName,
    this.remarks,
    this.totalAmount,
    this.paymentMethod,
    this.employeeName,
    this.employeePhoneNumber,
    this.rating,
    this.feedbackComments,
    this.beforePhotoUrl,
    this.afterPhotoUrl,
  });

  factory CustomerHistoryListData.fromJson(Map<String, dynamic> json) => CustomerHistoryListData(
    jobId: json["jobId"],
    requestedDate: json["requestedDate"] == null ? null : DateTime.parse(json["requestedDate"]),
    completedDate: json["completedDate"],
    priority: json["priority"],
    vendorName: json["vendorName"],
    remarks: json["remarks"],
    totalAmount: json["totalAmount"],
    paymentMethod: json["paymentMethod"],
    employeeName: json["employeeName"],
    employeePhoneNumber: json["employeePhoneNumber"],
    rating: json["rating"],
    feedbackComments: json["feedbackComments"],
    beforePhotoUrl: json["beforePhotoUrl"],
    afterPhotoUrl: json["afterPhotoUrl"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "requestedDate": requestedDate?.toIso8601String(),
    "completedDate": completedDate,
    "priority": priority,
    "vendorName": vendorName,
    "remarks": remarks,
    "totalAmount": totalAmount,
    "paymentMethod": paymentMethod,
    "employeeName": employeeName,
    "employeePhoneNumber": employeePhoneNumber,
    "rating": rating,
    "feedbackComments": feedbackComments,
    "beforePhotoUrl": beforePhotoUrl,
    "afterPhotoUrl": afterPhotoUrl,
  };
}
