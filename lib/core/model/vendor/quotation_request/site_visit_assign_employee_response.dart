// To parse this JSON data, do
//
//     final siteVisitAssignEmployeeResponse = siteVisitAssignEmployeeResponseFromJson(jsonString);

import 'dart:convert';

SiteVisitAssignEmployeeResponse siteVisitAssignEmployeeResponseFromJson(String str) => SiteVisitAssignEmployeeResponse.fromJson(json.decode(str));

String siteVisitAssignEmployeeResponseToJson(SiteVisitAssignEmployeeResponse data) => json.encode(data.toJson());

class SiteVisitAssignEmployeeResponse {
  bool? success;
  String? message;
  bool? data;

  SiteVisitAssignEmployeeResponse({
    this.success,
    this.message,
    this.data,
  });

  factory SiteVisitAssignEmployeeResponse.fromJson(Map<String, dynamic> json) => SiteVisitAssignEmployeeResponse(
    success: json["success"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data,
  };
}
