// To parse this JSON data, do
//
//     final customerIdRequest = customerIdRequestFromJson(jsonString);

import 'dart:convert';

CustomerIdRequest customerIdRequestFromJson(String str) => CustomerIdRequest.fromJson(json.decode(str));

String customerIdRequestToJson(CustomerIdRequest data) => json.encode(data.toJson());

class CustomerIdRequest {
  int? customerId;

  CustomerIdRequest({
    this.customerId,
  });

  factory CustomerIdRequest.fromJson(Map<String, dynamic> json) => CustomerIdRequest(
    customerId: json["customerId"],
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
  };
}


VendorIdRequest vendorIdRequestFromJson(String str) => VendorIdRequest.fromJson(json.decode(str));

String vendorIdRequestToJson(VendorIdRequest data) => json.encode(data.toJson());

class VendorIdRequest {
  int? vendorId;

  VendorIdRequest({
    this.vendorId,
  });

  factory VendorIdRequest.fromJson(Map<String, dynamic> json) => VendorIdRequest(
    vendorId: json["vendorId"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
  };
}