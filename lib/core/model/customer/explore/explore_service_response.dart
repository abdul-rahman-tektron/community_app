// To parse this JSON data, do
//
//     final exploreServiceResponse = exploreServiceResponseFromJson(jsonString);

import 'dart:convert';

ExploreServiceResponse exploreServiceResponseFromJson(String str) => ExploreServiceResponse.fromJson(json.decode(str));

String exploreServiceResponseToJson(ExploreServiceResponse data) => json.encode(data.toJson());

class ExploreServiceResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<ExploreServiceData>? data;

  ExploreServiceResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory ExploreServiceResponse.fromJson(Map<String, dynamic> json) => ExploreServiceResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<ExploreServiceData>.from(json["data"]!.map((x) => ExploreServiceData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class ExploreServiceData {
  int? serviceId;
  String? serviceName;
  String? serviceImage;
  String? vendorName;
  String? vendorLogo;
  int? rating;
  int? reviewCount;
  double? minPrice;
  double? maxPrice;
  dynamic categoryName;
  int? vendorId;

  ExploreServiceData({
    this.serviceId,
    this.serviceName,
    this.serviceImage,
    this.vendorName,
    this.vendorLogo,
    this.rating,
    this.reviewCount,
    this.minPrice,
    this.maxPrice,
    this.categoryName,
    this.vendorId,
  });

  factory ExploreServiceData.fromJson(Map<String, dynamic> json) => ExploreServiceData(
    serviceId: json["serviceId"],
    serviceName: json["serviceName"],
    serviceImage: json["serviceImage"],
    vendorName: json["vendorName"],
    vendorLogo: json["vendorLogo"],
    rating: json["rating"],
    reviewCount: json["reviewCount"],
    minPrice: json["minPrice"],
    maxPrice: json["maxPrice"],
    categoryName: json["categoryName"],
    vendorId: json["vendorId"],
  );

  Map<String, dynamic> toJson() => {
    "serviceId": serviceId,
    "serviceName": serviceName,
    "serviceImage": serviceImage,
    "vendorName": vendorName,
    "vendorLogo": vendorLogo,
    "rating": rating,
    "reviewCount": reviewCount,
    "minPrice": minPrice,
    "maxPrice": maxPrice,
    "categoryName": categoryName,
    "vendorId": vendorId,
  };
}
