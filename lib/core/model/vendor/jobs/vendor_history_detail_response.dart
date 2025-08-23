// To parse this JSON data, do
//
//     final vendorHistoryDetailResponse = vendorHistoryDetailResponseFromJson(jsonString);

import 'dart:convert';

VendorHistoryDetailResponse vendorHistoryDetailResponseFromJson(String str) => VendorHistoryDetailResponse.fromJson(json.decode(str));

String vendorHistoryDetailResponseToJson(VendorHistoryDetailResponse data) => json.encode(data.toJson());

class VendorHistoryDetailResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  VendorHistoryDetailData? data;

  VendorHistoryDetailResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory VendorHistoryDetailResponse.fromJson(Map<String, dynamic> json) => VendorHistoryDetailResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? null : VendorHistoryDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data?.toJson(),
  };
}

class VendorHistoryDetailData {
  JobDetail? jobDetail;
  List<CompletionDetail>? completionDetails;

  VendorHistoryDetailData({
    this.jobDetail,
    this.completionDetails,
  });

  factory VendorHistoryDetailData.fromJson(Map<String, dynamic> json) => VendorHistoryDetailData(
    jobDetail: json["jobDetail"] == null ? null : JobDetail.fromJson(json["jobDetail"]),
    completionDetails: json["completionDetails"] == null ? [] : List<CompletionDetail>.from(json["completionDetails"]!.map((x) => CompletionDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobDetail": jobDetail?.toJson(),
    "completionDetails": completionDetails == null ? [] : List<dynamic>.from(completionDetails!.map((x) => x.toJson())),
  };
}

class CompletionDetail {
  String? notes;
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
  String? jobTitle;
  String? status;
  DateTime? createdDate;
  String? assignedEmployee;
  double? totalAmount;
  String? remarks;
  int? rating;

  JobDetail({
    this.jobId,
    this.jobTitle,
    this.status,
    this.createdDate,
    this.assignedEmployee,
    this.totalAmount,
    this.remarks,
    this.rating,
  });

  factory JobDetail.fromJson(Map<String, dynamic> json) => JobDetail(
    jobId: json["jobId"],
    jobTitle: json["jobTitle"],
    status: json["status"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    assignedEmployee: json["assignedEmployee"],
    totalAmount: json["totalAmount"],
    remarks: json["remarks"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "jobTitle": jobTitle,
    "status": status,
    "createdDate": createdDate?.toIso8601String(),
    "assignedEmployee": assignedEmployee,
    "totalAmount": totalAmount,
    "remarks": remarks,
    "rating": rating,
  };
}
