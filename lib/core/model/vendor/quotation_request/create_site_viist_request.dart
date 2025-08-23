// To parse this JSON data, do
//
//     final createSiteVisitRequest = createSiteVisitRequestFromJson(jsonString);

import 'dart:convert';

CreateSiteVisitRequest createSiteVisitRequestFromJson(String str) => CreateSiteVisitRequest.fromJson(json.decode(str));

String createSiteVisitRequestToJson(CreateSiteVisitRequest data) => json.encode(data.toJson());

class CreateSiteVisitRequest {
  int? jobId;
  String? requestedBy;
  String? requestedTo;
  String? createdBy;
  int? vendorId;
  DateTime? requestedDate;
  int? customerId;

  CreateSiteVisitRequest({
    this.jobId,
    this.requestedBy,
    this.requestedTo,
    this.createdBy,
    this.vendorId,
    this.requestedDate,
    this.customerId,
  });

  factory CreateSiteVisitRequest.fromJson(Map<String, dynamic> json) => CreateSiteVisitRequest(
    jobId: json["jobId"],
    requestedBy: json["requestedBy"],
    requestedTo: json["requestedTo"],
    createdBy: json["createdBy"],
    vendorId: json["vendorId"],
    requestedDate: json["requestedDate"] == null ? null : DateTime.parse(json["requestedDate"]),
    customerId: json["customerId"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "requestedBy": requestedBy,
    "requestedTo": requestedTo,
    "createdBy": createdBy,
    "vendorId": vendorId,
    "requestedDate": requestedDate?.toIso8601String(),
    "customerId": customerId,
  };
}
