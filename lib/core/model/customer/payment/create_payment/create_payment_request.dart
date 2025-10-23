// To parse this JSON data, do
//
//     final createPaymentRequest = createPaymentRequestFromJson(jsonString);

import 'dart:convert';

CreatePaymentRequest createPaymentRequestFromJson(String str) => CreatePaymentRequest.fromJson(json.decode(str));

String createPaymentRequestToJson(CreatePaymentRequest data) => json.encode(data.toJson());

class CreatePaymentRequest {
  int? paymentIdentity;
  int? jobId;
  int? quotationId;
  int? amountFrom;
  int? amountTo;
  String? type;
  double? commPercentage;
  double? commAmount;
  double? amount;
  String? mode;
  String? paymentTowards;
  String? remarks;
  String? invoiceNumber;
  String? referenceNumber;
  String? referenceType;
  DateTime? transactionDate;
  String? transactionStatus;

  CreatePaymentRequest({
    this.paymentIdentity,
    this.jobId,
    this.quotationId,
    this.amountFrom,
    this.amountTo,
    this.type,
    this.commPercentage = 0,
    this.commAmount = 0,
    this.amount,
    this.mode,
    this.paymentTowards = "",
    this.remarks = "",
    this.invoiceNumber = "",
    this.referenceNumber = "",
    this.referenceType = "",
    this.transactionDate,
    this.transactionStatus = "",
  });

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) => CreatePaymentRequest(
    paymentIdentity: json["paymentIdentity"],
    jobId: json["jobId"],
    quotationId: json["quotationId"],
    amountFrom: json["amountFrom"],
    amountTo: json["amountTo"],
    type: json["type"],
    commPercentage: json["commPercentage"]?.toDouble(),
    commAmount: json["commAmount"]?.toDouble(),
    amount: json["amount"]?.toDouble(),
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
    "paymentIdentity": paymentIdentity,
    "jobId": jobId,
    "quotationId": quotationId,
    "amountFrom": amountFrom,
    "amountTo": amountTo,
    "type": type,
    "commPercentage": commPercentage,
    "commAmount": commAmount,
    "amount": amount,
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
