// To parse this JSON data, do
//
//     final changePasswordRequest = changePasswordRequestFromJson(jsonString);

import 'dart:convert';

ChangePasswordRequest changePasswordRequestFromJson(String str) => ChangePasswordRequest.fromJson(json.decode(str));

String changePasswordRequestToJson(ChangePasswordRequest data) => json.encode(data.toJson());

class ChangePasswordRequest {
  String? userId;
  String? oldPassword;
  String? newPassword;
  String? confirmPassword;
  String? modifiedBy;

  ChangePasswordRequest({
    this.userId,
    this.oldPassword,
    this.newPassword,
    this.confirmPassword,
    this.modifiedBy,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => ChangePasswordRequest(
    userId: json["userId"],
    oldPassword: json["oldPassword"],
    newPassword: json["newPassword"],
    confirmPassword: json["confirmPassword"],
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "oldPassword": oldPassword,
    "newPassword": newPassword,
    "confirmPassword": confirmPassword,
    "modifiedBy": modifiedBy,
  };
}
