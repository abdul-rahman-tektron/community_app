// To parse this JSON data, do
//
//     final jobStatusTrackingResponse = jobStatusTrackingResponseFromJson(jsonString);

import 'dart:convert';

JobStatusTrackingResponse jobStatusTrackingResponseFromJson(String str) => JobStatusTrackingResponse.fromJson(json.decode(str));

String jobStatusTrackingResponseToJson(JobStatusTrackingResponse data) => json.encode(data.toJson());

class JobStatusTrackingResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<JobStatusTrackingData>? data;

  JobStatusTrackingResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory JobStatusTrackingResponse.fromJson(Map<String, dynamic> json) => JobStatusTrackingResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<JobStatusTrackingData>.from(json["data"]!.map((x) => JobStatusTrackingData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class JobStatusTrackingData {
  int? jobStatusUpdateId;
  int? jobId;
  int? vendorId;
  int? statusId;
  String? status;
  int? progressPercent;
  String? category;
  String? description;
  String? customerRemarks;
  int? workDonePercentage;
  DateTime? createdDate;
  String? createdBy;

  JobStatusTrackingData({
    this.jobStatusUpdateId,
    this.jobId,
    this.vendorId,
    this.statusId,
    this.status,
    this.progressPercent,
    this.category,
    this.description,
    this.customerRemarks,
    this.workDonePercentage,
    this.createdDate,
    this.createdBy,
  });

  factory JobStatusTrackingData.fromJson(Map<String, dynamic> json) => JobStatusTrackingData(
    jobStatusUpdateId: json["jobStatusUpdateId"],
    jobId: json["jobId"],
    vendorId: json["vendorId"],
    statusId: json["statusId"],
    status: json["status"],
    progressPercent: json["progressPercent"],
    category: json["category"],
    description: json["description"],
    customerRemarks: json["customerRemarks"],
    workDonePercentage: json["workDonePercentage"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "jobStatusUpdateId": jobStatusUpdateId,
    "jobId": jobId,
    "vendorId": vendorId,
    "statusId": statusId,
    "status": status,
    "progressPercent": progressPercent,
    "category": category,
    "description": description,
    "customerRemarks": customerRemarks,
    "workDonePercentage": workDonePercentage,
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
  };
}
