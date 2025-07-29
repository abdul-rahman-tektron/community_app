// To parse this JSON data, do
//
//     final createJobBookingRequest = createJobBookingRequestFromJson(jsonString);

import 'dart:convert';

CreateJobBookingRequest createJobBookingRequestFromJson(String str) => CreateJobBookingRequest.fromJson(json.decode(str));

String createJobBookingRequestToJson(CreateJobBookingRequest data) => json.encode(data.toJson());

class CreateJobBookingRequest {
  int? jobId;
  int? quotationRequestId;
  int? quotationResponseId;
  int? vendorId;
  String? remarks;
  String? createdBy;

  CreateJobBookingRequest({
    this.jobId,
    this.quotationRequestId,
    this.quotationResponseId,
    this.vendorId,
    this.remarks,
    this.createdBy,
  });

  factory CreateJobBookingRequest.fromJson(Map<String, dynamic> json) => CreateJobBookingRequest(
    jobId: json["jobId"],
    quotationRequestId: json["quotationRequestId"],
    quotationResponseId: json["quotationResponseId"],
    vendorId: json["vendorId"],
    remarks: json["remarks"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "quotationRequestId": quotationRequestId,
    "quotationResponseId": quotationResponseId,
    "vendorId": vendorId,
    "remarks": remarks,
    "createdBy": createdBy,
  };
}
