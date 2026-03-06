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
  String? vendorName;
  int? siteVisitId;
  bool? isAcceptedByCustomer;
  String? quotationDetails;
  double? quotationAmount;
  int? serviceCharge;
  DateTime? startDate;
  DateTime? endDate;
  String? createdBy;
  DateTime? createdDate;
  String? status;
  int? quotationResponceId;
  DateTime? requestedDate;
  bool? requiredPartialPayment;
  List<JobQuotationResponseItem>? jobQuotationResponseItems;

  VendorCreateJobQuotationRequest({
    this.jobId,
    this.quotationRequestId,
    this.serviceId,
    this.vendorId,
    this.vendorName,
    this.siteVisitId,
    this.isAcceptedByCustomer,
    this.quotationDetails,
    this.quotationAmount,
    this.serviceCharge,
    this.startDate,
    this.endDate,
    this.createdBy,
    this.createdDate,
    this.status,
    this.quotationResponceId,
    this.requestedDate,
    this.requiredPartialPayment,
    this.jobQuotationResponseItems,
  });

  factory VendorCreateJobQuotationRequest.fromJson(Map<String, dynamic> json) => VendorCreateJobQuotationRequest(
    jobId: json["jobId"],
    quotationRequestId: json["quotationRequestId"],
    serviceId: json["serviceId"],
    vendorId: json["vendorId"],
    vendorName: json["vendorName"],
    siteVisitId: json["siteVisitId"],
    isAcceptedByCustomer: json["isAcceptedByCustomer"],
    quotationDetails: json["quotationDetails"],
    quotationAmount: json["quotationAmount"],
    serviceCharge: json["serviceCharge"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    createdBy: json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    status: json["status"],
    quotationResponceId: json["quotationResponceId"],
    requestedDate: json["requestedDate"] == null ? null : DateTime.parse(json["requestedDate"]),
    requiredPartialPayment: json["requiredPartialPayment"],
    jobQuotationResponseItems: json["jobQuotationResponseItems"] == null ? [] : List<JobQuotationResponseItem>.from(json["jobQuotationResponseItems"]!.map((x) => JobQuotationResponseItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "quotationRequestId": quotationRequestId,
    "serviceId": serviceId,
    "vendorId": vendorId,
    "vendorName": vendorName,
    "siteVisitId": siteVisitId,
    "isAcceptedByCustomer": isAcceptedByCustomer,
    "quotationDetails": quotationDetails,
    "quotationAmount": quotationAmount,
    "serviceCharge": serviceCharge,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
    "status": status,
    "quotationResponceId": quotationResponceId,
    "requestedDate": requestedDate?.toIso8601String(),
    "requiredPartialPayment": requiredPartialPayment,
    "jobQuotationResponseItems": jobQuotationResponseItems == null ? [] : List<dynamic>.from(jobQuotationResponseItems!.map((x) => x.toJson())),
  };
}

class JobQuotationResponseItem {
  int? quotationResponceId;
  String? product;
  int? quantity;
  int? price;
  int? totalAmount;

  JobQuotationResponseItem({
    this.quotationResponceId,
    this.product,
    this.quantity,
    this.price,
    this.totalAmount,
  });

  factory JobQuotationResponseItem.fromJson(Map<String, dynamic> json) => JobQuotationResponseItem(
    quotationResponceId: json["quotationResponceId"],
    product: json["product"],
    quantity: json["quantity"],
    price: json["price"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "quotationResponceId": quotationResponceId,
    "product": product,
    "quantity": quantity,
    "price": price,
    "totalAmount": totalAmount,
  };
}
