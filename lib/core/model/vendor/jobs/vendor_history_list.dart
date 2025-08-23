// To parse this JSON data, do
//
//     final vendorHistoryListResponse = vendorHistoryListResponseFromJson(jsonString);

import 'dart:convert';

VendorHistoryListResponse vendorHistoryListResponseFromJson(String str) => VendorHistoryListResponse.fromJson(json.decode(str));

String vendorHistoryListResponseToJson(VendorHistoryListResponse data) => json.encode(data.toJson());

class VendorHistoryListResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<VendorHistoryListData>? data;

  VendorHistoryListResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory VendorHistoryListResponse.fromJson(Map<String, dynamic> json) => VendorHistoryListResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<VendorHistoryListData>.from(json["data"]!.map((x) => VendorHistoryListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class VendorHistoryListData {
  int? jobId;
  String? customerName;
  String? serviceName;
  String? address;
  int? quotedAmount;
  DateTime? date;

  VendorHistoryListData({
    this.jobId,
    this.customerName,
    this.serviceName,
    this.address,
    this.quotedAmount,
    this.date,
  });

  factory VendorHistoryListData.fromJson(Map<String, dynamic> json) => VendorHistoryListData(
    jobId: json["jobId"],
    customerName: json["customerName"],
    serviceName: json["serviceName"],
    address: json["address"],
    quotedAmount: json["quotedAmount"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "customerName": customerName,
    "serviceName": serviceName,
    "address": address,
    "quotedAmount": quotedAmount,
    "date": date?.toIso8601String(),
  };
}
