// To parse this JSON data, do
//
//     final customerHistoryDetailResponse = customerHistoryDetailResponseFromJson(jsonString);

import 'dart:convert';

CustomerHistoryDetailResponse customerHistoryDetailResponseFromJson(String str) => CustomerHistoryDetailResponse.fromJson(json.decode(str));

String customerHistoryDetailResponseToJson(CustomerHistoryDetailResponse data) => json.encode(data.toJson());

class CustomerHistoryDetailResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  CustomerHistoryDetailData? data;

  CustomerHistoryDetailResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory CustomerHistoryDetailResponse.fromJson(Map<String, dynamic> json) => CustomerHistoryDetailResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? null : CustomerHistoryDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data?.toJson(),
  };
}

class CustomerHistoryDetailData {
  JobDetail? jobDetail;
  List<CompletionDetail>? completionDetails;

  CustomerHistoryDetailData({
    this.jobDetail,
    this.completionDetails,
  });

  factory CustomerHistoryDetailData.fromJson(Map<String, dynamic> json) => CustomerHistoryDetailData(
    jobDetail: json["jobDetail"] == null ? null : JobDetail.fromJson(json["jobDetail"]),
    completionDetails: json["completionDetails"] == null ? [] : List<CompletionDetail>.from(json["completionDetails"]!.map((x) => CompletionDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobDetail": jobDetail?.toJson(),
    "completionDetails": completionDetails == null ? [] : List<dynamic>.from(completionDetails!.map((x) => x.toJson())),
  };
}

class CompletionDetail {
  dynamic notes;
  String? beforePhotoUrl;
  String? afterPhotoUrl;
  dynamic employeeName;
  dynamic employeePhoneNumber;

  CompletionDetail({
    this.notes,
    this.beforePhotoUrl,
    this.afterPhotoUrl,
    this.employeeName,
    this.employeePhoneNumber,
  });

  factory CompletionDetail.fromJson(Map<String, dynamic> json) => CompletionDetail(
    notes: json["notes"],
    beforePhotoUrl: json["beforePhotoUrl"],
    afterPhotoUrl: json["afterPhotoUrl"],
    employeeName: json["employeeName"],
    employeePhoneNumber: json["employeePhoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "notes": notes,
    "beforePhotoUrl": beforePhotoUrl,
    "afterPhotoUrl": afterPhotoUrl,
    "employeeName": employeeName,
    "employeePhoneNumber": employeePhoneNumber,
  };
}

class JobDetail {
  int? jobId;
  DateTime? requestedDate;
  DateTime? completedDate;
  String? priority;
  String? vendorName;
  String? vendorPhoneNumber;
  String? remarks;
  double? totalAmount;
  String? paymentMethod;
  String? employeeName;
  dynamic employeePhoneNumber;
  int? rating;
  String? feedbackComments;

  JobDetail({
    this.jobId,
    this.requestedDate,
    this.completedDate,
    this.priority,
    this.vendorName,
    this.vendorPhoneNumber,
    this.remarks,
    this.totalAmount,
    this.paymentMethod,
    this.employeeName,
    this.employeePhoneNumber,
    this.rating,
    this.feedbackComments,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) => JobDetail(
    jobId: json["jobId"],
    requestedDate: json["requestedDate"] == null ? null : DateTime.parse(json["requestedDate"]),
    completedDate: json["completedDate"] == null ? null : DateTime.parse(json["completedDate"]),
    priority: json["priority"],
    vendorName: json["vendorName"],
    vendorPhoneNumber: json["vendorPhoneNumber"],
    remarks: json["remarks"],
    totalAmount: json["totalAmount"],
    paymentMethod: json["paymentMethod"],
    employeeName: json["employeeName"],
    employeePhoneNumber: json["employeePhoneNumber"],
    rating: json["rating"],
    feedbackComments: json["feedbackComments"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "requestedDate": requestedDate?.toIso8601String(),
    "completedDate": completedDate?.toIso8601String(),
    "priority": priority,
    "vendorName": vendorName,
    "vendorPhoneNumber": vendorPhoneNumber,
    "remarks": remarks,
    "totalAmount": totalAmount,
    "paymentMethod": paymentMethod,
    "employeeName": employeeName,
    "employeePhoneNumber": employeePhoneNumber,
    "rating": rating,
    "feedbackComments": feedbackComments,
  };
}
