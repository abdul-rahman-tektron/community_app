// To parse this JSON data, do
//
//     final jobInfoDetailResponse = jobInfoDetailResponseFromJson(jsonString);

import 'dart:convert';

JobInfoDetailResponse jobInfoDetailResponseFromJson(String str) => JobInfoDetailResponse.fromJson(json.decode(str));

String jobInfoDetailResponseToJson(JobInfoDetailResponse data) => json.encode(data.toJson());

class JobInfoDetailResponse {
  String? customerName;
  String? serviceName;
  String? phoneNumber;
  String? address;
  DateTime? expectedDate;
  String? priority;
  String? fileContent;
  String? remarks;

  JobInfoDetailResponse({
    this.customerName,
    this.serviceName,
    this.phoneNumber,
    this.address,
    this.expectedDate,
    this.priority,
    this.fileContent,
    this.remarks,
  });

  factory JobInfoDetailResponse.fromJson(Map<String, dynamic> json) => JobInfoDetailResponse(
    customerName: json["customerName"],
    serviceName: json["serviceName"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    expectedDate: json["expectedDate"] == null ? null : DateTime.parse(json["expectedDate"]),
    priority: json["priority"],
    fileContent: json["fileContent"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "customerName": customerName,
    "serviceName": serviceName,
    "phoneNumber": phoneNumber,
    "address": address,
    "expectedDate": expectedDate?.toIso8601String(),
    "priority": priority,
    "fileContent": fileContent,
    "remarks": remarks,
  };
}
