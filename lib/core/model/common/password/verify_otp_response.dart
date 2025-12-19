// To parse this JSON data, do
//
//     final verifyOtpResponse = verifyOtpResponseFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponse verifyOtpResponseFromJson(String str) => VerifyOtpResponse.fromJson(json.decode(str));

String verifyOtpResponseToJson(VerifyOtpResponse data) => json.encode(data.toJson());

class VerifyOtpResponse {
  bool? isValid;
  String? userId;

  VerifyOtpResponse({
    this.isValid,
    this.userId,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
    isValid: json["isValid"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "isValid": isValid,
    "userId": userId,
  };
}
