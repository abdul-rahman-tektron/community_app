// To parse this JSON data, do
//
//     final getAllVendorServiceResponse = getAllVendorServiceResponseFromJson(jsonString);

import 'dart:convert';

List<GetAllVendorServiceResponse> getAllVendorServiceResponseFromJson(String str) => List<GetAllVendorServiceResponse>.from(json.decode(str).map((x) => GetAllVendorServiceResponse.fromJson(x)));

String getAllVendorServiceResponseToJson(List<GetAllVendorServiceResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetAllVendorServiceResponse {
  int? iIdentity;
  int? vendorId;
  dynamic vendorName;
  int? serviceId;
  dynamic service;
  bool? deleted;
  bool? active;
  DateTime? createdDate;
  String? createdBy;
  dynamic modifiedDate;
  dynamic modifiedBy;
  dynamic description;
  dynamic image;
  dynamic address;
  dynamic rating;
  dynamic reviewCount;
  dynamic averageResponseTime;

  GetAllVendorServiceResponse({
    this.iIdentity,
    this.vendorId,
    this.vendorName,
    this.serviceId,
    this.service,
    this.deleted,
    this.active,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
    this.description,
    this.image,
    this.address,
    this.rating,
    this.reviewCount,
    this.averageResponseTime,
  });

  factory GetAllVendorServiceResponse.fromJson(Map<String, dynamic> json) => GetAllVendorServiceResponse(
    iIdentity: json["iIdentity"],
    vendorId: json["vendorId"],
    vendorName: json["vendorName"],
    serviceId: json["serviceId"],
    service: json["service"],
    deleted: json["deleted"],
    active: json["active"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"],
    modifiedBy: json["modifiedBy"],
    description: json["description"],
    image: json["image"],
    address: json["address"],
    rating: json["rating"],
    reviewCount: json["reviewCount"],
    averageResponseTime: json["averageResponseTime"],
  );

  Map<String, dynamic> toJson() => {
    "iIdentity": iIdentity,
    "vendorId": vendorId,
    "vendorName": vendorName,
    "serviceId": serviceId,
    "service": service,
    "deleted": deleted,
    "active": active,
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate,
    "modifiedBy": modifiedBy,
    "description": description,
    "image": image,
    "address": address,
    "rating": rating,
    "reviewCount": reviewCount,
    "averageResponseTime": averageResponseTime,
  };
}
