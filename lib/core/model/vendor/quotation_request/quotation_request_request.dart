// To parse this JSON data, do
//
//     final quotationRequestRequest = quotationRequestRequestFromJson(jsonString);

import 'dart:convert';

QuotationRequestRequest quotationRequestRequestFromJson(String str) => QuotationRequestRequest.fromJson(json.decode(str));

String quotationRequestRequestToJson(QuotationRequestRequest data) => json.encode(data.toJson());

class QuotationRequestRequest {
  int? jobId;
  int? serviceId;
  int? vendorId;
  String? vendorName;
  int? customerId;
  int? fromCustomerId;
  bool? active;
  String? createdBy;
  String? status;
  List<JobQuotationRequestItem>? jobQuotationRequestItems;

  QuotationRequestRequest({
    this.jobId,
    this.serviceId,
    this.vendorId,
    this.vendorName,
    this.customerId,
    this.fromCustomerId,
    this.active,
    this.createdBy,
    this.status,
    this.jobQuotationRequestItems,
  });

  factory QuotationRequestRequest.fromJson(Map<String, dynamic> json) => QuotationRequestRequest(
    jobId: json["jobId"],
    serviceId: json["serviceId"],
    vendorId: json["vendorId"],
    vendorName: json["vendorName"],
    customerId: json["customerId"],
    fromCustomerId: json["FromCustomerId"],
    active: json["active"],
    createdBy: json["createdBy"],
    status: json["status"],
    jobQuotationRequestItems: json["jobQuotationRequestItems"] == null ? [] : List<JobQuotationRequestItem>.from(json["jobQuotationRequestItems"]!.map((x) => JobQuotationRequestItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "serviceId": serviceId,
    "vendorId": vendorId,
    "vendorName": vendorName,
    "customerId": customerId,
    "FromCustomerId": fromCustomerId,
    "active": active,
    "createdBy": createdBy,
    "status": status,
    "jobQuotationRequestItems": jobQuotationRequestItems == null ? [] : List<dynamic>.from(jobQuotationRequestItems!.map((x) => x.toJson())),
  };
}

class JobQuotationRequestItem {
  int? vendorId;

  JobQuotationRequestItem({
    this.vendorId,
  });

  factory JobQuotationRequestItem.fromJson(Map<String, dynamic> json) => JobQuotationRequestItem(
    vendorId: json["vendorId"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
  };
}
