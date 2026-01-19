// To parse this JSON data, do
//
//     final setPasswordRequest = setPasswordRequestFromJson(jsonString);

import 'dart:convert';

SetPasswordRequest setPasswordRequestFromJson(String str) => SetPasswordRequest.fromJson(json.decode(str));

String setPasswordRequestToJson(SetPasswordRequest data) => json.encode(data.toJson());

class SetPasswordRequest {
  String? userId;
  String? password;

  SetPasswordRequest({
    this.userId,
    this.password,
  });

  factory SetPasswordRequest.fromJson(Map<String, dynamic> json) => SetPasswordRequest(
    userId: json["userId"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "password": password,
  };
}