// To parse this JSON data, do
//
//     final vendorQuotationRequestListResponse = vendorQuotationRequestListResponseFromJson(jsonString);

import 'dart:convert';

VendorQuotationRequestListResponse vendorQuotationRequestListResponseFromJson(String str) => VendorQuotationRequestListResponse.fromJson(json.decode(str));

String vendorQuotationRequestListResponseToJson(VendorQuotationRequestListResponse data) => json.encode(data.toJson());

class VendorQuotationRequestListResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<VendorQuotationRequestData>? data;

  VendorQuotationRequestListResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory VendorQuotationRequestListResponse.fromJson(Map<String, dynamic> json) => VendorQuotationRequestListResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<VendorQuotationRequestData>.from(json["data"]!.map((x) => VendorQuotationRequestData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class VendorQuotationRequestData {
  int? quotationId;
  dynamic quotationResponseId;
  int? jobId;
  int? fromCustomerId;
  int? toVendorId;
  dynamic quotationRequestStatus;
  String? quotationResponseStatus;
  dynamic remarks;
  bool? deleted;
  bool? active;
  DateTime? createdDate;
  String? createdBy;
  dynamic modifiedDate;
  dynamic modifiedBy;

  VendorQuotationRequestData({
    this.quotationId,
    this.quotationResponseId,
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

  factory VendorQuotationRequestData.fromJson(Map<String, dynamic> json) => VendorQuotationRequestData(
    quotationId: json["quotationId"],
    quotationResponseId: json["quotationResponseId"],
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
    "quotationResponseId": quotationResponseId,
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
