// To parse this JSON data, do
//
//     final quotationRequestListResponse = quotationRequestListResponseFromJson(jsonString);

import 'dart:convert';

QuotationRequestListResponse quotationRequestListResponseFromJson(String str) => QuotationRequestListResponse.fromJson(json.decode(str));

String quotationRequestListResponseToJson(QuotationRequestListResponse data) => json.encode(data.toJson());

class QuotationRequestListResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  List<QuotationRequestListData>? data;

  QuotationRequestListResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory QuotationRequestListResponse.fromJson(Map<String, dynamic> json) => QuotationRequestListResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? [] : List<QuotationRequestListData>.from(json["data"]!.map((x) => QuotationRequestListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class QuotationRequestListData {
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
  List<MediaList>? mediaList;
  dynamic distributions;
  List<JobQuotationRequest>? jobQuotationRequest;

  QuotationRequestListData({
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
    this.mediaList,
    this.distributions,
    this.jobQuotationRequest,
  });

  factory QuotationRequestListData.fromJson(Map<String, dynamic> json) => QuotationRequestListData(
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
    modifiedDate: json["modifiedDate"],
    mediaList: json["mediaList"] == null ? [] : List<MediaList>.from(json["mediaList"]!.map((x) => MediaList.fromJson(x))),
    distributions: json["distributions"],
    jobQuotationRequest: json["jobQuotationRequest"] == null ? [] : List<JobQuotationRequest>.from(json["jobQuotationRequest"]!.map((x) => JobQuotationRequest.fromJson(x))),
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
    "mediaList": mediaList == null ? [] : List<dynamic>.from(mediaList!.map((x) => x.toJson())),
    "distributions": distributions,
    "jobQuotationRequest": jobQuotationRequest == null ? [] : List<dynamic>.from(jobQuotationRequest!.map((x) => x.toJson())),
  };
}

class JobQuotationRequest {
  int? jobId;
  int? serviceId;
  int? toVendorId;
  int? fromCustomerId;
  bool? active;
  String? createdBy;
  DateTime? createdDate;
  dynamic modifiedBy;
  dynamic modifiedDate;
  dynamic status;
  int? quotationId;
  dynamic jobQuotationRequestItems;
  dynamic statusId;
  bool? hasQuotationResponse;

  JobQuotationRequest({
    this.jobId,
    this.serviceId,
    this.toVendorId,
    this.fromCustomerId,
    this.active,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.status,
    this.quotationId,
    this.jobQuotationRequestItems,
    this.statusId,
    this.hasQuotationResponse,
  });

  factory JobQuotationRequest.fromJson(Map<String, dynamic> json) => JobQuotationRequest(
    jobId: json["jobId"],
    serviceId: json["serviceId"],
    toVendorId: json["toVendorId"],
    fromCustomerId: json["fromCustomerId"],
    active: json["active"],
    createdBy: json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    modifiedBy: json["modifiedBy"],
    modifiedDate: json["modifiedDate"],
    status: json["status"],
    quotationId: json["quotationId"],
    jobQuotationRequestItems: json["jobQuotationRequestItems"],
    statusId: json["statusId"],
    hasQuotationResponse: json["hasQuotationResponse"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "serviceId": serviceId,
    "toVendorId": toVendorId,
    "fromCustomerId": fromCustomerId,
    "active": active,
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedDate": modifiedDate,
    "status": status,
    "quotationId": quotationId,
    "jobQuotationRequestItems": jobQuotationRequestItems,
    "statusId": statusId,
    "hasQuotationResponse": hasQuotationResponse,
  };
}

class MediaList {
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

  MediaList({
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

  factory MediaList.fromJson(Map<String, dynamic> json) => MediaList(
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
