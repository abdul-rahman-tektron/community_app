// To parse this JSON data, do
//
//     final customerRegisterResponse = customerRegisterResponseFromJson(jsonString);

import 'dart:convert';

CustomerRegisterResponse customerRegisterResponseFromJson(String str) => CustomerRegisterResponse.fromJson(json.decode(str));

String customerRegisterResponseToJson(CustomerRegisterResponse data) => json.encode(data.toJson());

class CustomerRegisterResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  dynamic data;

  CustomerRegisterResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory CustomerRegisterResponse.fromJson(Map<String, dynamic> json) => CustomerRegisterResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data,
  };
}
