// To parse this JSON data, do
//
//     final serviceDetailResponse = serviceDetailResponseFromJson(jsonString);

import 'dart:convert';

ServiceDetailResponse serviceDetailResponseFromJson(String str) => ServiceDetailResponse.fromJson(json.decode(str));

String serviceDetailResponseToJson(ServiceDetailResponse data) => json.encode(data.toJson());

class ServiceDetailResponse {
  bool? success;
  String? message;
  ServiceDetailData? data;

  ServiceDetailResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) => ServiceDetailResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : ServiceDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class ServiceDetailData {
  int? serviceId;
  int? vendorId;
  String? serviceName;
  double? price;
  String? description;

  ServiceDetailData({
    this.serviceId,
    this.vendorId,
    this.serviceName,
    this.price,
    this.description,
  });

  factory ServiceDetailData.fromJson(Map<String, dynamic> json) => ServiceDetailData(
    serviceId: json["serviceId"],
    vendorId: json["vendorId"],
    serviceName: json["serviceName"],
    price: json["price"]?.toDouble(),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "serviceId": serviceId,
    "vendorId": vendorId,
    "serviceName": serviceName,
    "price": price,
    "description": description,
  };
}
