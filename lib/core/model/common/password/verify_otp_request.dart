// To parse this JSON data, do
//
//     final verifyOtpRequest = verifyOtpRequestFromJson(jsonString);

import 'dart:convert';

VerifyOtpRequest verifyOtpRequestFromJson(String str) => VerifyOtpRequest.fromJson(json.decode(str));

String verifyOtpRequestToJson(VerifyOtpRequest data) => json.encode(data.toJson());

class VerifyOtpRequest {
  String? email;
  String? otp;

  VerifyOtpRequest({
    this.email,
    this.otp,
  });

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => VerifyOtpRequest(
    email: json["email"],
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "otp": otp,
  };
}
