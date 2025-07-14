// To parse this JSON data, do
//
//     final createJobRequest = createJobRequestFromJson(jsonString);

import 'dart:convert';

CreateJobRequest createJobRequestFromJson(String str) => CreateJobRequest.fromJson(json.decode(str));

String createJobRequestToJson(CreateJobRequest data) => json.encode(data.toJson());

class CreateJobRequest {
  int? jobId;
  int? customerId;
  String? remarks;
  String? status;
  DateTime? expectedDate;
  String? contactNumber;
  String? priority;
  String? createdBy;
  List<JobMediaList>? mediaList;

  CreateJobRequest({
    this.jobId,
    this.customerId,
    this.remarks,
    this.status,
    this.expectedDate,
    this.contactNumber,
    this.priority,
    this.createdBy,
    this.mediaList,
  });

  factory CreateJobRequest.fromJson(Map<String, dynamic> json) => CreateJobRequest(
    jobId: json["jobId"],
    customerId: json["customerId"],
    remarks: json["remarks"],
    status: json["status"],
    expectedDate: json["expectedDate"] == null ? null : DateTime.parse(json["expectedDate"]),
    contactNumber: json["contactNumber"],
    priority: json["priority"],
    createdBy: json["createdBy"],
    mediaList: json["mediaList"] == null ? [] : List<JobMediaList>.from(json["mediaList"]!.map((x) => JobMediaList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "customerId": customerId,
    "remarks": remarks,
    "status": status,
    "expectedDate": expectedDate?.toIso8601String(),
    "contactNumber": contactNumber,
    "priority": priority,
    "createdBy": createdBy,
    "mediaList": mediaList == null ? [] : List<dynamic>.from(mediaList!.map((x) => x.toJson())),
  };
}

class JobMediaList {
  String? photoVideoType;
  String? fileContent;
  String? type;

  JobMediaList({
    this.photoVideoType,
    this.fileContent,
    this.type,
  });

  factory JobMediaList.fromJson(Map<String, dynamic> json) => JobMediaList(
    photoVideoType: json["photoVideoType"],
    fileContent: json["fileContent"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "photoVideoType": photoVideoType,
    "fileContent": fileContent,
    "type": type,
  };
}
