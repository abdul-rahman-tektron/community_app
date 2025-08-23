// To parse this JSON data, do
//
//     final createSiteVisitResponse = createSiteVisitResponseFromJson(jsonString);

import 'dart:convert';

CreateSiteVisitResponse createSiteVisitResponseFromJson(String str) => CreateSiteVisitResponse.fromJson(json.decode(str));

String createSiteVisitResponseToJson(CreateSiteVisitResponse data) => json.encode(data.toJson());

class CreateSiteVisitResponse {
  bool? success;
  String? message;
  int? data;

  CreateSiteVisitResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CreateSiteVisitResponse.fromJson(Map<String, dynamic> json) => CreateSiteVisitResponse(
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
