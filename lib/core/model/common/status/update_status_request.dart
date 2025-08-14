// To parse this JSON data, do
//
//     final updateStatusRequest = updateStatusRequestFromJson(jsonString);

import 'dart:convert';

UpdateStatusRequest updateStatusRequestFromJson(String str) => UpdateStatusRequest.fromJson(json.decode(str));

String updateStatusRequestToJson(UpdateStatusRequest data) => json.encode(data.toJson());

class UpdateStatusRequest {
  int? jobId;
  String? notes;
  int? statusId;
  String? feedback;
  String? createdBy;

  UpdateStatusRequest({
    this.jobId,
    this.notes,
    this.statusId,
    this.feedback,
    this.createdBy,
  });

  factory UpdateStatusRequest.fromJson(Map<String, dynamic> json) => UpdateStatusRequest(
    jobId: json["jobId"],
    notes: json["notes"],
    statusId: json["statusId"],
    feedback: json["feedback"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "notes": notes,
    "statusId": statusId,
    "feedback": feedback,
    "createdBy": createdBy,
  };
}
