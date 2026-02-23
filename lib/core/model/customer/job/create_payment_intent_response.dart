// To parse this JSON data, do
//
//     final createPaymentIntentResponse = createPaymentIntentResponseFromJson(jsonString);

import 'dart:convert';

CreatePaymentIntentResponse createPaymentIntentResponseFromJson(String str) => CreatePaymentIntentResponse.fromJson(json.decode(str));

String createPaymentIntentResponseToJson(CreatePaymentIntentResponse data) => json.encode(data.toJson());

class CreatePaymentIntentResponse {
  String? clientSecret;
  String? stripePaymentIntentId;

  CreatePaymentIntentResponse({
    this.clientSecret,
    this.stripePaymentIntentId,
  });

  factory CreatePaymentIntentResponse.fromJson(Map<String, dynamic> json) => CreatePaymentIntentResponse(
    clientSecret: json["clientSecret"],
    stripePaymentIntentId: json["stripePaymentIntentId"],
  );

  Map<String, dynamic> toJson() => {
    "clientSecret": clientSecret,
    "stripePaymentIntentId": stripePaymentIntentId,
  };
}
