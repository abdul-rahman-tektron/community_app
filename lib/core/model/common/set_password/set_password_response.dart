

// To parse this JSON data, do
//
//     final setPasswordResponse = setPasswordResponseFromJson(jsonString);

import 'dart:convert';

SetPasswordResponse setPasswordResponseFromJson(String str) => SetPasswordResponse.fromJson(json.decode(str));

String setPasswordResponseToJson(SetPasswordResponse data) => json.encode(data.toJson());

class SetPasswordResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  dynamic data;

  SetPasswordResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory SetPasswordResponse.fromJson(Map<String, dynamic> json) => SetPasswordResponse(
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