// To parse this JSON data, do
//
//     final vendorCreateJobQuotationRequest = vendorCreateJobQuotationRequestFromJson(jsonString);

import 'dart:convert';

VendorCreateJobQuotationRequest vendorCreateJobQuotationRequestFromJson(String str) => VendorCreateJobQuotationRequest.fromJson(json.decode(str));

String vendorCreateJobQuotationRequestToJson(VendorCreateJobQuotationRequest data) => json.encode(data.toJson());

class VendorCreateJobQuotationRequest {
  int? jobId;
  int? quotationRequestId;
  int? serviceId;
  int? vendorId;
  String? quotationDetails;
  int? quotationAmount;
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  String? createdBy;
  List<JobQuotationResponseItem>? jobQuotationResponseItems;

  VendorCreateJobQuotationRequest({
    this.jobId,
    this.quotationRequestId,
    this.serviceId,
    this.vendorId,
    this.quotationDetails,
    this.quotationAmount,
    this.startDate,
    this.endDate,
    this.status,
    this.createdBy,
    this.jobQuotationResponseItems,
  });

  factory VendorCreateJobQuotationRequest.fromJson(Map<String, dynamic> json) => VendorCreateJobQuotationRequest(
    jobId: json["jobId"],
    quotationRequestId: json["quotationRequestId"],
    serviceId: json["serviceId"],
    vendorId: json["vendorId"],
    quotationDetails: json["quotationDetails"],
    quotationAmount: json["quotationAmount"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    status: json["status"],
    createdBy: json["createdBy"],
    jobQuotationResponseItems: json["jobQuotationResponseItems"] == null ? [] : List<JobQuotationResponseItem>.from(json["jobQuotationResponseItems"]!.map((x) => JobQuotationResponseItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "quotationRequestId": quotationRequestId,
    "serviceId": serviceId,
    "vendorId": vendorId,
    "quotationDetails": quotationDetails,
    "quotationAmount": quotationAmount,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "status": status,
    "createdBy": createdBy,
    "jobQuotationResponseItems": jobQuotationResponseItems == null ? [] : List<dynamic>.from(jobQuotationResponseItems!.map((x) => x.toJson())),
  };
}

class JobQuotationResponseItem {
  String? product;
  int? quantity;
  int? price;
  int? totalAmount;

  JobQuotationResponseItem({
    this.product,
    this.quantity,
    this.price,
    this.totalAmount,
  });

  factory JobQuotationResponseItem.fromJson(Map<String, dynamic> json) => JobQuotationResponseItem(
    product: json["product"],
    quantity: json["quantity"],
    price: json["price"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "product": product,
    "quantity": quantity,
    "price": price,
    "totalAmount": totalAmount,
  };
}
