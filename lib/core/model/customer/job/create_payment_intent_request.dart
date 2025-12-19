// To parse this JSON data, do
//
//     final createPaymentIntentRequest = createPaymentIntentRequestFromJson(jsonString);

import 'dart:convert';

CreatePaymentIntentRequest createPaymentIntentRequestFromJson(String str) => CreatePaymentIntentRequest.fromJson(json.decode(str));

String createPaymentIntentRequestToJson(CreatePaymentIntentRequest data) => json.encode(data.toJson());

class CreatePaymentIntentRequest {
  int? amount;
  String? currency;
  int? paymentIdentity;
  String? stripePaymentIntentId;
  int? jobId;
  int? quotationId;
  int? amountFrom;
  int? amountTo;
  String? type;
  int? commPercentage;
  int? commAmount;
  int? totalAmount;
  String? mode;
  String? paymentTowards;
  String? remarks;
  String? invoiceNumber;
  String? referenceNumber;
  String? referenceType;
  DateTime? transactionDate;
  String? transactionStatus;

  CreatePaymentIntentRequest({
    this.amount,
    this.currency,
    this.paymentIdentity,
    this.stripePaymentIntentId,
    this.jobId,
    this.quotationId,
    this.amountFrom,
    this.amountTo,
    this.type,
    this.commPercentage,
    this.commAmount,
    this.totalAmount,
    this.mode,
    this.paymentTowards,
    this.remarks,
    this.invoiceNumber,
    this.referenceNumber,
    this.referenceType,
    this.transactionDate,
    this.transactionStatus,
  });

  factory CreatePaymentIntentRequest.fromJson(Map<String, dynamic> json) => CreatePaymentIntentRequest(
    amount: json["amount"],
    currency: json["currency"],
    paymentIdentity: json["paymentIdentity"],
    stripePaymentIntentId: json["stripePaymentIntentId"],
    jobId: json["jobId"],
    quotationId: json["quotationId"],
    amountFrom: json["amountFrom"],
    amountTo: json["amountTo"],
    type: json["type"],
    commPercentage: json["commPercentage"],
    commAmount: json["commAmount"],
    totalAmount: json["totalAmount"],
    mode: json["mode"],
    paymentTowards: json["paymentTowards"],
    remarks: json["remarks"],
    invoiceNumber: json["invoiceNumber"],
    referenceNumber: json["referenceNumber"],
    referenceType: json["referenceType"],
    transactionDate: json["transactionDate"] == null ? null : DateTime.parse(json["transactionDate"]),
    transactionStatus: json["transactionStatus"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "currency": currency,
    "paymentIdentity": paymentIdentity,
    "stripePaymentIntentId": stripePaymentIntentId,
    "jobId": jobId,
    "quotationId": quotationId,
    "amountFrom": amountFrom,
    "amountTo": amountTo,
    "type": type,
    "commPercentage": commPercentage,
    "commAmount": commAmount,
    "totalAmount": totalAmount,
    "mode": mode,
    "paymentTowards": paymentTowards,
    "remarks": remarks,
    "invoiceNumber": invoiceNumber,
    "referenceNumber": referenceNumber,
    "referenceType": referenceType,
    "transactionDate": transactionDate?.toIso8601String(),
    "transactionStatus": transactionStatus,
  };
}
