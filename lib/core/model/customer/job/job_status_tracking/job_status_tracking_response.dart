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
  JobStatusData? data;

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
    data: json["data"] == null ? null : JobStatusData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data?.toJson(),
  };
}

class JobStatusData {
  List<JobStatusTrackingData>? statusTracking;
  List<PartyInfo>? partyInfo;

  JobStatusData({
    this.statusTracking,
    this.partyInfo,
  });

  factory JobStatusData.fromJson(Map<String, dynamic> json) => JobStatusData(
    statusTracking: json["statusTracking"] == null ? [] : List<JobStatusTrackingData>.from(json["statusTracking"]!.map((x) => JobStatusTrackingData.fromJson(x))),
    partyInfo: json["partyInfo"] == null ? [] : List<PartyInfo>.from(json["partyInfo"]!.map((x) => PartyInfo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusTracking": statusTracking == null ? [] : List<dynamic>.from(statusTracking!.map((x) => x.toJson())),
    "partyInfo": partyInfo == null ? [] : List<dynamic>.from(partyInfo!.map((x) => x.toJson())),
  };
}

class PartyInfo {
  String? customerName;
  double? longitude;
  double? latitude;
  String? mobile;
  String? vendorName;
  double? vendorLongitude;
  double? vendorLatitude;
  String? vendorMobile;
  String? employeePhoneNumber;
  String? employeeName;

  PartyInfo({
    this.customerName,
    this.longitude,
    this.latitude,
    this.mobile,
    this.vendorName,
    this.vendorLongitude,
    this.vendorLatitude,
    this.vendorMobile,
    this.employeePhoneNumber,
    this.employeeName,
  });

  factory PartyInfo.fromJson(Map<String, dynamic> json) => PartyInfo(
    customerName: json["customerName"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    mobile: json["mobile"],
    vendorName: json["vendorName"],
    vendorLongitude: json["vendorLongitude"]?.toDouble(),
    vendorLatitude: json["vendorLatitude"]?.toDouble(),
    vendorMobile: json["vendorMobile"],
    employeePhoneNumber: json["employeePhoneNumber"],
    employeeName: json["employeeName"],
  );

  Map<String, dynamic> toJson() => {
    "customerName": customerName,
    "longitude": longitude,
    "latitude": latitude,
    "mobile": mobile,
    "vendorName": vendorName,
    "vendorLongitude": vendorLongitude,
    "vendorLatitude": vendorLatitude,
    "vendorMobile": vendorMobile,
    "employeePhoneNumber": employeePhoneNumber,
    "employeeName": employeeName,
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
