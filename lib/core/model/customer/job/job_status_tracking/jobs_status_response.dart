// To parse this JSON data, do
//
//     final jobStatusResponse = jobStatusResponseFromJson(jsonString);

import 'dart:convert';

List<JobStatusResponse> jobStatusResponseFromJson(String str) => List<JobStatusResponse>.from(json.decode(str).map((x) => JobStatusResponse.fromJson(x)));

String jobStatusResponseToJson(List<JobStatusResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobStatusResponse {
  int? statusId;
  String? status;
  int? progressPercent;
  String? category;
  String? description;

  JobStatusResponse({
    this.statusId,
    this.status,
    this.progressPercent,
    this.category,
    this.description,
  });

  factory JobStatusResponse.fromJson(Map<String, dynamic> json) => JobStatusResponse(
    statusId: json["statusId"],
    status: json["status"],
    progressPercent: json["progressPercent"],
    category: json["category"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "statusId": statusId,
    "status": status,
    "progressPercent": progressPercent,
    "category": category,
    "description": description,
  };
}
