// To parse this JSON data, do
//
//     final paymentStatusResponse = paymentStatusResponseFromJson(jsonString);

import 'dart:convert';

PaymentStatusResponse paymentStatusResponseFromJson(String str) => PaymentStatusResponse.fromJson(json.decode(str));

String paymentStatusResponseToJson(PaymentStatusResponse data) => json.encode(data.toJson());

class PaymentStatusResponse {
  String? stripePaymentIntentId;
  String? transactionStatus;
  double? amount;
  String? currency;
  dynamic updatedDate;

  PaymentStatusResponse({
    this.stripePaymentIntentId,
    this.transactionStatus,
    this.amount,
    this.currency,
    this.updatedDate,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) => PaymentStatusResponse(
    stripePaymentIntentId: json["stripePaymentIntentId"],
    transactionStatus: json["transactionStatus"],
    amount: json["amount"],
    currency: json["currency"],
    updatedDate: json["updatedDate"],
  );

  Map<String, dynamic> toJson() => {
    "stripePaymentIntentId": stripePaymentIntentId,
    "transactionStatus": transactionStatus,
    "amount": amount,
    "currency": currency,
    "updatedDate": updatedDate,
  };
}
