// To parse this JSON data, do
//
//     final resetPasswordRequest = resetPasswordRequestFromJson(jsonString);

import 'dart:convert';

ResetPasswordRequest resetPasswordRequestFromJson(String str) => ResetPasswordRequest.fromJson(json.decode(str));

String resetPasswordRequestToJson(ResetPasswordRequest data) => json.encode(data.toJson());

class ResetPasswordRequest {
  String? email;
  String? otp;
  String? newPassword;

  ResetPasswordRequest({
    this.email,
    this.otp,
    this.newPassword,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => ResetPasswordRequest(
    email: json["email"],
    otp: json["otp"],
    newPassword: json["newPassword"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "otp": otp,
    "newPassword": newPassword,
  };
}
