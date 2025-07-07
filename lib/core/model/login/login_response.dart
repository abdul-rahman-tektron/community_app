
// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String? email;
  String? token;

  LoginResponse({
    this.email,
    this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    email: json["email"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "token": token,
  };
}
