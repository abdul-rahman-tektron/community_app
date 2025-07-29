// To parse this JSON data, do
//
//     final jobCompletionRequest = jobCompletionRequestFromJson(jsonString);

import 'dart:convert';

JobCompletionRequest jobCompletionRequestFromJson(String str) => JobCompletionRequest.fromJson(json.decode(str));

String jobCompletionRequestToJson(JobCompletionRequest data) => json.encode(data.toJson());

class JobCompletionRequest {
  int? jobId;
  String? createdBy;
  List<PhotoPair>? photoPairs;
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
    photoPairs: json["photoPairs"] == null ? [] : List<PhotoPair>.from(json["photoPairs"]!.map((x) => PhotoPair.fromJson(x))),
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "CreatedBy": createdBy,
    "photoPairs": photoPairs == null ? [] : List<dynamic>.from(photoPairs!.map((x) => x.toJson())),
    "notes": notes,
  };
}

class PhotoPair {
  String? beforePhoto;
  String? afterPhoto;

  PhotoPair({
    this.beforePhoto,
    this.afterPhoto,
  });

  factory PhotoPair.fromJson(Map<String, dynamic> json) => PhotoPair(
    beforePhoto: json["beforePhoto"],
    afterPhoto: json["afterPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "beforePhoto": beforePhoto,
    "afterPhoto": afterPhoto,
  };
}
