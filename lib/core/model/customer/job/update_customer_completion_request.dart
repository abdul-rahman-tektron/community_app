// To parse this JSON data, do
//
//     final updateCustomerCompletionRequest = updateCustomerCompletionRequestFromJson(jsonString);

import 'dart:convert';

UpdateCustomerCompletionRequest updateCustomerCompletionRequestFromJson(String str) => UpdateCustomerCompletionRequest.fromJson(json.decode(str));

String updateCustomerCompletionRequestToJson(UpdateCustomerCompletionRequest data) => json.encode(data.toJson());

class UpdateCustomerCompletionRequest {
  int? jobId;
  String? notes;
  int? workDonePercentage;
  int? rating;
  String? feedback;
  String? createdBy;

  UpdateCustomerCompletionRequest({
    this.jobId,
    this.notes,
    this.workDonePercentage,
    this.rating,
    this.feedback,
    this.createdBy,
  });

  factory UpdateCustomerCompletionRequest.fromJson(Map<String, dynamic> json) => UpdateCustomerCompletionRequest(
    jobId: json["jobId"],
    notes: json["notes"],
    workDonePercentage: json["workDonePercentage"],
    rating: json["rating"],
    feedback: json["feedback"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "notes": notes,
    "workDonePercentage": workDonePercentage,
    "rating": rating,
    "feedback": feedback,
    "createdBy": createdBy,
  };
}
