// To parse this JSON data, do
//
//     final createPaymentResponse = createPaymentResponseFromJson(jsonString);

import 'dart:convert';

CreatePaymentResponse createPaymentResponseFromJson(String str) => CreatePaymentResponse.fromJson(json.decode(str));

String createPaymentResponseToJson(CreatePaymentResponse data) => json.encode(data.toJson());

class CreatePaymentResponse {
  int? paymentIdentity;
  String? message;

  CreatePaymentResponse({
    this.paymentIdentity,
    this.message,
  });

  factory CreatePaymentResponse.fromJson(Map<String, dynamic> json) => CreatePaymentResponse(
    paymentIdentity: json["paymentIdentity"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "paymentIdentity": paymentIdentity,
    "message": message,
  };
}
