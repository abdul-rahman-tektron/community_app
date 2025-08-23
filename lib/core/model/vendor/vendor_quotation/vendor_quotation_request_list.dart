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
  int? quotationResponseId;
  int? jobId;
  int? fromCustomerId;
  int? toVendorId;
  String? quotationRequestStatus;
  String? quotationResponseStatus;
  String? customerName;
  String? customerMobile;
  String? customerAddress;
  String? serviceName;
  DateTime? expectedDate;
  int? serviceId;
  String? remarks;
  bool? deleted;
  bool? active;
  bool? siteVisit;
  int? siteVisitId;
  DateTime? createdDate;
  String? createdBy;
  dynamic modifiedDate;
  dynamic modifiedBy;
  num? quotationAmount;

  VendorQuotationRequestData({
    this.quotationId,
    this.quotationResponseId,
    this.jobId,
    this.fromCustomerId,
    this.toVendorId,
    this.quotationRequestStatus,
    this.quotationResponseStatus,
    this.customerName,
    this.customerMobile,
    this.customerAddress,
    this.serviceName,
    this.expectedDate,
    this.serviceId,
    this.remarks,
    this.deleted,
    this.active,
    this.siteVisit,
    this.siteVisitId,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
    this.quotationAmount,
  });

  factory VendorQuotationRequestData.fromJson(Map<String, dynamic> json) => VendorQuotationRequestData(
    quotationId: json["quotationId"],
    quotationResponseId: json["quotationResponseId"],
    jobId: json["jobId"],
    fromCustomerId: json["fromCustomerId"],
    toVendorId: json["toVendorId"],
    quotationRequestStatus: json["quotationRequestStatus"],
    quotationResponseStatus: json["quotationResponseStatus"],
    customerName: json["customerName"],
    customerMobile: json["customerMobile"],
    customerAddress: json["customerAddress"],
    serviceName: json["serviceName"],
    expectedDate: json["expectedDate"] == null ? null : DateTime.parse(json["expectedDate"]),
    serviceId: json["serviceId"],
    remarks: json["remarks"],
    deleted: json["deleted"],
    active: json["active"],
    siteVisit: json["siteVisit"],
    siteVisitId: json["siteVisitId"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"],
    modifiedBy: json["modifiedBy"],
    quotationAmount: json["quotationAmount"],
  );

  Map<String, dynamic> toJson() => {
    "quotationId": quotationId,
    "quotationResponseId": quotationResponseId,
    "jobId": jobId,
    "fromCustomerId": fromCustomerId,
    "toVendorId": toVendorId,
    "quotationRequestStatus": quotationRequestStatus,
    "quotationResponseStatus": quotationResponseStatus,
    "customerName": customerName,
    "customerMobile": customerMobile,
    "customerAddress": customerAddress,
    "serviceName": serviceName,
    "expectedDate": expectedDate?.toIso8601String(),
    "serviceId": serviceId,
    "remarks": remarks,
    "deleted": deleted,
    "active": active,
    "siteVisit": siteVisit,
    "siteVisitId": siteVisitId,
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate,
    "modifiedBy": modifiedBy,
    "quotationAmount": quotationAmount,
  };
}
