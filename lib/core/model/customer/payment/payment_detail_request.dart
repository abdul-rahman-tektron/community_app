import 'dart:convert';

PaymentDetailRequest paymentDetailRequestFromJson(String str) => PaymentDetailRequest.fromJson(json.decode(str));

String paymentDetailRequestToJson(PaymentDetailRequest data) => json.encode(data.toJson());

class PaymentDetailRequest {
  int? vendorId;
  int? jobId;

  PaymentDetailRequest({
    this.vendorId,
    this.jobId,
  });

  factory PaymentDetailRequest.fromJson(Map<String, dynamic> json) => PaymentDetailRequest(
    vendorId: json["vendorId"],
    jobId: json["jobId"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "jobId": jobId,
  };
}
