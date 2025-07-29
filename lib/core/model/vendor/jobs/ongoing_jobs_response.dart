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
  int? quotationId;
  int? jobId;
  int? fromCustomerId;
  int? toVendorId;
  String? quotationRequestStatus;
  String? quotationResponseStatus;
  String? remarks;
  bool? deleted;
  bool? active;
  DateTime? createdDate;
  String? createdBy;
  dynamic modifiedDate;
  dynamic modifiedBy;

  OngoingJobsData({
    this.quotationId,
    this.jobId,
    this.fromCustomerId,
    this.toVendorId,
    this.quotationRequestStatus,
    this.quotationResponseStatus,
    this.remarks,
    this.deleted,
    this.active,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
  });

  factory OngoingJobsData.fromJson(Map<String, dynamic> json) => OngoingJobsData(
    quotationId: json["quotationId"],
    jobId: json["jobId"],
    fromCustomerId: json["fromCustomerId"],
    toVendorId: json["toVendorId"],
    quotationRequestStatus: json["quotationRequestStatus"],
    quotationResponseStatus: json["quotationResponseStatus"],
    remarks: json["remarks"],
    deleted: json["deleted"],
    active: json["active"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"],
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "quotationId": quotationId,
    "jobId": jobId,
    "fromCustomerId": fromCustomerId,
    "toVendorId": toVendorId,
    "quotationRequestStatus": quotationRequestStatus,
    "quotationResponseStatus": quotationResponseStatus,
    "remarks": remarks,
    "deleted": deleted,
    "active": active,
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate,
    "modifiedBy": modifiedBy,
  };
}
