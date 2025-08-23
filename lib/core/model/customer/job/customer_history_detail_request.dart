// To parse this JSON data, do
//
//     final customerHistoryDetailRequest = customerHistoryDetailRequestFromJson(jsonString);

import 'dart:convert';

CustomerHistoryDetailRequest customerHistoryDetailRequestFromJson(String str) => CustomerHistoryDetailRequest.fromJson(json.decode(str));

String customerHistoryDetailRequestToJson(CustomerHistoryDetailRequest data) => json.encode(data.toJson());

class CustomerHistoryDetailRequest {
  int? customerId;
  int? jobId;

  CustomerHistoryDetailRequest({
    this.customerId,
    this.jobId,
  });

  factory CustomerHistoryDetailRequest.fromJson(Map<String, dynamic> json) => CustomerHistoryDetailRequest(
    customerId: json["customerId"],
    jobId: json["jobId"],
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "jobId": jobId,
  };
}
