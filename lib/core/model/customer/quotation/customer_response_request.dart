// To parse this JSON data, do
//
//     final customerResponseRequest = customerResponseRequestFromJson(jsonString);

import 'dart:convert';

CustomerResponseRequest customerResponseRequestFromJson(String str) => CustomerResponseRequest.fromJson(json.decode(str));

String customerResponseRequestToJson(CustomerResponseRequest data) => json.encode(data.toJson());

class CustomerResponseRequest {
  int? jobid;
  int? siteVisitId;
  bool? isAccepted;

  CustomerResponseRequest({
    this.jobid,
    this.siteVisitId,
    this.isAccepted,
  });

  factory CustomerResponseRequest.fromJson(Map<String, dynamic> json) => CustomerResponseRequest(
    jobid: json["jobid"],
    siteVisitId: json["siteVisitId"],
    isAccepted: json["isAccepted"],
  );

  Map<String, dynamic> toJson() => {
    "jobid": jobid,
    "siteVisitId": siteVisitId,
    "isAccepted": isAccepted,
  };
}
