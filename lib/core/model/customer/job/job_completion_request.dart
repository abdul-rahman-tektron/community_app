// To parse this JSON data, do
//
//     final jobCompletionRequest = jobCompletionRequestFromJson(jsonString);

import 'dart:convert';

JobCompletionRequest jobCompletionRequestFromJson(String str) => JobCompletionRequest.fromJson(json.decode(str));

String jobCompletionRequestToJson(JobCompletionRequest data) => json.encode(data.toJson());

class JobCompletionRequest {
  int? jobId;
  String? createdBy;
  List<JobCompletionPhotoPair>? photoPairs;
  String? notes;

  JobCompletionRequest({
    this.jobId,
    this.createdBy,
    this.photoPairs,
    this.notes,
  });

  factory JobCompletionRequest.fromJson(Map<String, dynamic> json) => JobCompletionRequest(
    jobId: json["jobId"],
    createdBy: json["CreatedBy"],
    photoPairs: json["photoPairs"] == null ? [] : List<JobCompletionPhotoPair>.from(json["photoPairs"]!.map((x) => JobCompletionPhotoPair.fromJson(x))),
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "CreatedBy": createdBy,
    "photoPairs": photoPairs == null ? [] : List<dynamic>.from(photoPairs!.map((x) => x.toJson())),
    "notes": notes,
  };
}

class JobCompletionPhotoPair {
  String? beforePhoto;
  String? afterPhoto;

  JobCompletionPhotoPair({
    this.beforePhoto,
    this.afterPhoto,
  });

  factory JobCompletionPhotoPair.fromJson(Map<String, dynamic> json) => JobCompletionPhotoPair(
    beforePhoto: json["beforePhoto"],
    afterPhoto: json["afterPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "beforePhoto": beforePhoto,
    "afterPhoto": afterPhoto,
  };
}
