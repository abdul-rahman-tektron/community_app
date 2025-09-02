// To parse this JSON data, do
//
//     final updateJobStatusRequest = updateJobStatusRequestFromJson(jsonString);

import 'dart:convert';

UpdateJobStatusRequest updateJobStatusRequestFromJson(String str) => UpdateJobStatusRequest.fromJson(json.decode(str));

String updateJobStatusRequestToJson(UpdateJobStatusRequest data) => json.encode(data.toJson());

class UpdateJobStatusRequest {
  int? jobId;
  String? notes;
  int? statusId;
  int? vendorId;
  String? feedback;
  String? createdBy;

  UpdateJobStatusRequest({
    this.jobId,
    this.notes,
    this.statusId,
    this.vendorId,
    this.feedback,
    this.createdBy,
  });

  factory UpdateJobStatusRequest.fromJson(Map<String, dynamic> json) => UpdateJobStatusRequest(
    jobId: json["jobId"],
    notes: json["notes"],
    statusId: json["statusId"],
    vendorId: json["vendorId"],
    feedback: json["feedback"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "notes": notes ?? "",
    "statusId": statusId,
    "vendorId": vendorId,
    "feedback": feedback ?? "",
    "createdBy": createdBy ?? "Admin",
  };
}
