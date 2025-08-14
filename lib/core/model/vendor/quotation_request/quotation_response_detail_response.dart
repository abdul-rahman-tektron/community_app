// To parse this JSON data, do
//
//     final quotationResponseDetailResponse = quotationResponseDetailResponseFromJson(jsonString);

import 'dart:convert';

QuotationResponseDetailResponse quotationResponseDetailResponseFromJson(String str) => QuotationResponseDetailResponse.fromJson(json.decode(str));

String quotationResponseDetailResponseToJson(QuotationResponseDetailResponse data) => json.encode(data.toJson());

class QuotationResponseDetailResponse {
  int? quotationResponseId;
  int? jobId;
  int? quotationRequestId;
  int? fromVendorId;
  String? quotationDetails;
  double? quotationAmount;
  int? serviceCharge;
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  String? createdBy;
  DateTime? createdDate;
  bool? deleted;
  bool? active;
  List<QuotationResponseDetailResponseItem>? items;

  QuotationResponseDetailResponse({
    this.quotationResponseId,
    this.jobId,
    this.quotationRequestId,
    this.fromVendorId,
    this.quotationDetails,
    this.quotationAmount,
    this.serviceCharge,
    this.startDate,
    this.endDate,
    this.status,
    this.createdBy,
    this.createdDate,
    this.deleted,
    this.active,
    this.items,
  });

  factory QuotationResponseDetailResponse.fromJson(Map<String, dynamic> json) => QuotationResponseDetailResponse(
    quotationResponseId: json["quotationResponseId"],
    jobId: json["jobId"],
    quotationRequestId: json["quotationRequestId"],
    fromVendorId: json["fromVendorId"],
    quotationDetails: json["quotationDetails"],
    quotationAmount: json["quotationAmount"],
    serviceCharge: json["serviceCharge"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
    status: json["status"],
    createdBy: json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    deleted: json["deleted"],
    active: json["active"],
    items: json["items"] == null ? [] : List<QuotationResponseDetailResponseItem>.from(json["items"]!.map((x) => QuotationResponseDetailResponseItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "quotationResponseId": quotationResponseId,
    "jobId": jobId,
    "quotationRequestId": quotationRequestId,
    "fromVendorId": fromVendorId,
    "quotationDetails": quotationDetails,
    "quotationAmount": quotationAmount,
    "serviceCharge": serviceCharge,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "status": status,
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
    "deleted": deleted,
    "active": active,
    "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class QuotationResponseDetailResponseItem {
  int? itemId;
  String? product;
  int? quantity;
  double? price;
  double? totalAmount;
  String? createdBy;
  DateTime? createdDate;

  QuotationResponseDetailResponseItem({
    this.itemId,
    this.product,
    this.quantity,
    this.price,
    this.totalAmount,
    this.createdBy,
    this.createdDate,
  });

  factory QuotationResponseDetailResponseItem.fromJson(Map<String, dynamic> json) => QuotationResponseDetailResponseItem(
    itemId: json["itemId"],
    product: json["product"],
    quantity: json["quantity"],
    price: json["price"],
    totalAmount: json["totalAmount"],
    createdBy: json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
  );

  Map<String, dynamic> toJson() => {
    "itemId": itemId,
    "product": product,
    "quantity": quantity,
    "price": price,
    "totalAmount": totalAmount,
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
  };
}
