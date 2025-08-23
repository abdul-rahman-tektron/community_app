// To parse this JSON data, do
//
//     final vendorHistoryDetailRequest = vendorHistoryDetailRequestFromJson(jsonString);

import 'dart:convert';

VendorHistoryDetailRequest vendorHistoryDetailRequestFromJson(String str) => VendorHistoryDetailRequest.fromJson(json.decode(str));

String vendorHistoryDetailRequestToJson(VendorHistoryDetailRequest data) => json.encode(data.toJson());

class VendorHistoryDetailRequest {
  int? jobId;
  int? vendorId;

  VendorHistoryDetailRequest({
    this.jobId,
    this.vendorId,
  });

  factory VendorHistoryDetailRequest.fromJson(Map<String, dynamic> json) => VendorHistoryDetailRequest(
    jobId: json["jobId"],
    vendorId: json["vendorId"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "vendorId": vendorId,
  };
}
