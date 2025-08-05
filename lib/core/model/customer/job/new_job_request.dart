// To parse this JSON data, do
//
//     final createJobRequest = createJobRequestFromJson(jsonString);

import 'dart:convert';

CreateJobRequest createJobRequestFromJson(String str) => CreateJobRequest.fromJson(json.decode(str));

String createJobRequestToJson(CreateJobRequest data) => json.encode(data.toJson());

class CreateJobRequest {
  int? jobId;
  int? serviceId;
  int? customerId;
  String? remarks;
  String? status;
  bool? active;
  bool? siteVisitRequired;
  DateTime? expectedDate;
  String? contactNumber;
  String? priority;
  String? createdBy;
  List<JobMediaList>? mediaList;

  CreateJobRequest({
    this.jobId,
    this.serviceId,
    this.customerId,
    this.remarks,
    this.status,
    this.active,
    this.siteVisitRequired,
    this.expectedDate,
    this.contactNumber,
    this.priority,
    this.createdBy,
    this.mediaList,
  });

  factory CreateJobRequest.fromJson(Map<String, dynamic> json) => CreateJobRequest(
    jobId: json["jobId"],
    serviceId: json["serviceId"],
    customerId: json["customerId"],
    remarks: json["remarks"],
    status: json["status"],
    active: json["active"],
    siteVisitRequired: json["siteVisitRequired"],
    expectedDate: json["expectedDate"] == null ? null : DateTime.parse(json["expectedDate"]),
    contactNumber: json["contactNumber"],
    priority: json["priority"],
    createdBy: json["createdBy"],
    mediaList: json["mediaList"] == null ? [] : List<JobMediaList>.from(json["mediaList"]!.map((x) => JobMediaList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "serviceId": serviceId,
    "customerId": customerId,
    "remarks": remarks,
    "active": active,
    "siteVisitRequired": siteVisitRequired,
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
  int? identity;
  int? jobId;
  String? from;
  int? customerId;
  int? vendorId;
  int? uid;
  int? inRefUID;

  JobMediaList({
    this.photoVideoType,
    this.fileContent,
    this.type,
    this.identity,
    this.jobId,
    this.from,
    this.customerId,
    this.vendorId,
    this.uid,
    this.inRefUID,
  });

  factory JobMediaList.fromJson(Map<String, dynamic> json) => JobMediaList(
    photoVideoType: json["photoVideoType"],
    fileContent: json["fileContent"],
    type: json["type"],
    identity: json["identity"],
    jobId: json["jobId"],
    from: json["from"],
    customerId: json["customerId"],
    vendorId: json["vendorId"],
    uid: json["uid"],
    inRefUID: json["inRefUID"],
  );

  Map<String, dynamic> toJson() => {
    "photoVideoType": photoVideoType,
    "fileContent": fileContent,
    "type": type,
    "identity": identity,
    "jobId": jobId,
    "from": from,
    "customerId": customerId,
    "vendorId": vendorId,
    "uid": uid,
    "inRefUID": inRefUID,
  };
}

