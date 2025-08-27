// To parse this JSON data, do
//
//     final serviceDetailRequest = serviceDetailRequestFromJson(jsonString);

import 'dart:convert';

ServiceDetailRequest serviceDetailRequestFromJson(String str) => ServiceDetailRequest.fromJson(json.decode(str));

String serviceDetailRequestToJson(ServiceDetailRequest data) => json.encode(data.toJson());

class ServiceDetailRequest {
  int? vendorId;
  int? serviceId;

  ServiceDetailRequest({
    this.vendorId,
    this.serviceId,
  });

  factory ServiceDetailRequest.fromJson(Map<String, dynamic> json) => ServiceDetailRequest(
    vendorId: json["vendorId"],
    serviceId: json["serviceId"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "serviceId": serviceId,
  };
}
