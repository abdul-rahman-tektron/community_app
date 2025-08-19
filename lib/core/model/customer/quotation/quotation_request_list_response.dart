// To parse this JSON data, do
//
//     final customerRequestListResponse = customerRequestListResponseFromJson(jsonString);

import 'dart:convert';

CustomerRequestListResponse customerRequestListResponseFromJson(String str) => CustomerRequestListResponse.fromJson(json.decode(str));

String customerRequestListResponseToJson(CustomerRequestListResponse data) => json.encode(data.toJson());

class CustomerRequestListResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<CustomerRequestListData>? data;

  CustomerRequestListResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory CustomerRequestListResponse.fromJson(Map<String, dynamic> json) => CustomerRequestListResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<CustomerRequestListData>.from(json["data"]!.map((x) => CustomerRequestListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CustomerRequestListData {
  int? jobId;
  int? customerId;
  int? serviceId;
  String? remarks;
  String? status;
  bool? active;
  DateTime? expectedDate;
  dynamic contactNumber;
  String? priority;
  String? createdBy;
  DateTime? createdDate;
  dynamic modifiedBy;
  dynamic modifiedDate;
  bool? siteVisitRequired;
  List<CustomerRequestMediaList>? mediaList;
  List<dynamic>? distributions;
  dynamic jobQuotationRequest;

  CustomerRequestListData({
    this.jobId,
    this.customerId,
    this.serviceId,
    this.remarks,
    this.status,
    this.active,
    this.expectedDate,
    this.contactNumber,
    this.priority,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.siteVisitRequired,
    this.mediaList,
    this.distributions,
    this.jobQuotationRequest,
  });

  factory CustomerRequestListData.fromJson(Map<String, dynamic> json) => CustomerRequestListData(
    jobId: json["jobId"],
    customerId: json["customerId"],
    serviceId: json["serviceId"],
    remarks: json["remarks"],
    status: json["status"],
    active: json["active"],
    expectedDate: json["expectedDate"] == null ? null : DateTime.parse(json["expectedDate"]),
    contactNumber: json["contactNumber"],
    priority: json["priority"],
    createdBy: json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    modifiedBy: json["modifiedBy"],
    siteVisitRequired: json["siteVisitRequired"],
    modifiedDate: json["modifiedDate"],
    mediaList: json["mediaList"] == null ? [] : List<CustomerRequestMediaList>.from(json["mediaList"]!.map((x) => CustomerRequestMediaList.fromJson(x))),
    distributions: json["distributions"] == null ? [] : List<dynamic>.from(json["distributions"]!.map((x) => x)),
    jobQuotationRequest: json["jobQuotationRequest"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "customerId": customerId,
    "serviceId": serviceId,
    "remarks": remarks,
    "status": status,
    "active": active,
    "expectedDate": expectedDate?.toIso8601String(),
    "contactNumber": contactNumber,
    "priority": priority,
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedDate": modifiedDate,
    "siteVisitRequired": siteVisitRequired,
    "mediaList": mediaList == null ? [] : List<dynamic>.from(mediaList!.map((x) => x.toJson())),
    "distributions": distributions == null ? [] : List<dynamic>.from(distributions!.map((x) => x)),
    "jobQuotationRequest": jobQuotationRequest,
  };
}

class CustomerRequestMediaList {
  int? iIdentity;
  int? jobId;
  String? from;
  int? customerId;
  int? vendorId;
  int? uid;
  String? photoVideoType;
  String? fileContent;
  String? type;
  int? inRefUid;
  bool? active;
  String? createdBy;
  DateTime? createdDate;
  dynamic modifiedBy;
  dynamic modifiedDate;

  CustomerRequestMediaList({
    this.iIdentity,
    this.jobId,
    this.from,
    this.customerId,
    this.vendorId,
    this.uid,
    this.photoVideoType,
    this.fileContent,
    this.type,
    this.inRefUid,
    this.active,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory CustomerRequestMediaList.fromJson(Map<String, dynamic> json) => CustomerRequestMediaList(
    iIdentity: json["iIdentity"],
    jobId: json["jobId"],
    from: json["from"],
    customerId: json["customerId"],
    vendorId: json["vendorId"],
    uid: json["uid"],
    photoVideoType: json["photoVideoType"],
    fileContent: json["fileContent"],
    type: json["type"],
    inRefUid: json["inRefUID"],
    active: json["active"],
    createdBy: json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    modifiedBy: json["modifiedBy"],
    modifiedDate: json["modifiedDate"],
  );

  Map<String, dynamic> toJson() => {
    "iIdentity": iIdentity,
    "jobId": jobId,
    "from": from,
    "customerId": customerId,
    "vendorId": vendorId,
    "uid": uid,
    "photoVideoType": photoVideoType,
    "fileContent": fileContent,
    "type": type,
    "inRefUID": inRefUid,
    "active": active,
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedDate": modifiedDate,
  };
}
