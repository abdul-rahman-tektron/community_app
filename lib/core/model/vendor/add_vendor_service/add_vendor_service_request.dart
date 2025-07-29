// To parse this JSON data, do
//
//     final addVendorServiceRequest = addVendorServiceRequestFromJson(jsonString);

import 'dart:convert';

AddVendorServiceRequest addVendorServiceRequestFromJson(String str) => AddVendorServiceRequest.fromJson(json.decode(str));

String addVendorServiceRequestToJson(AddVendorServiceRequest data) => json.encode(data.toJson());

class AddVendorServiceRequest {
  int? vendorId;
  String? vendorName;
  int? serviceId;
  int? service;
  bool? active;
  String? createdBy;
  String? description;
  String? image;

  AddVendorServiceRequest({
    this.vendorId,
    this.vendorName,
    this.serviceId,
    this.service,
    this.active = true,
    this.createdBy,
    this.description,
    this.image,
  });

  factory AddVendorServiceRequest.fromJson(Map<String, dynamic> json) => AddVendorServiceRequest(
    vendorId: json["vendorId"],
    vendorName: json["vendorName"],
    serviceId: json["serviceId"],
    service: json["service"],
    active: json["active"],
    createdBy: json["createdBy"],
    description: json["description"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "vendorName": vendorName,
    "serviceId": serviceId,
    "service": service,
    "active": active,
    "createdBy": createdBy,
    "description": description,
    "image": image,
  };
}
