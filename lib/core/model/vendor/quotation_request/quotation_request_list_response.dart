// To parse this JSON data, do
//
//     final quotationRequestListResponse = quotationRequestListResponseFromJson(jsonString);

import 'dart:convert';

QuotationRequestListResponse quotationRequestListResponseFromJson(String str) =>
    QuotationRequestListResponse.fromJson(json.decode(str));

String quotationRequestListResponseToJson(QuotationRequestListResponse data) =>
    json.encode(data.toJson());

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

  factory QuotationRequestListResponse.fromJson(Map<String, dynamic> json) =>
      QuotationRequestListResponse(
        success: json["success"],
        message: json["message"],
        uniqueId: json["uniqueId"],
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        data: json["data"] == null
            ? []
            : List<QuotationRequestListData>.from(
                json["data"]!.map((x) => QuotationRequestListData.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
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
  bool? siteVisitRequired;
  dynamic modifiedBy;
  dynamic modifiedDate;
  List<MediaList>? mediaList;
  dynamic distributions;
  List<JobQuotationRequest>? jobQuotationRequest;
  List<JobQuotationResponce>? jobQuotationResponce; // ✅ added this

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
    this.siteVisitRequired,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
    this.mediaList,
    this.distributions,
    this.jobQuotationRequest,
    this.jobQuotationResponce, // ✅ added
  });

  factory QuotationRequestListData.fromJson(Map<String, dynamic> json) =>
      QuotationRequestListData(
        jobId: json["jobId"],
        customerId: json["customerId"],
        serviceId: json["serviceId"],
        remarks: json["remarks"],
        status: json["status"],
        active: json["active"],
        siteVisitRequired: json["siteVisitRequired"],
        expectedDate: json["expectedDate"] == null
            ? null
            : DateTime.parse(json["expectedDate"]),
        contactNumber: json["contactNumber"],
        priority: json["priority"],
        createdBy: json["createdBy"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedBy: json["modifiedBy"],
        modifiedDate: json["modifiedDate"],
        mediaList: json["mediaList"] == null
            ? []
            : List<MediaList>.from(
                json["mediaList"]!.map((x) => MediaList.fromJson(x)),
              ),
        distributions: json["distributions"],
        jobQuotationRequest: json["jobQuotationRequest"] == null
            ? []
            : List<JobQuotationRequest>.from(
                json["jobQuotationRequest"]!.map(
                  (x) => JobQuotationRequest.fromJson(x),
                ),
              ),
        jobQuotationResponce: json["jobQuotationResponce"] == null
            ? []
            : List<JobQuotationResponce>.from(
                json["jobQuotationResponce"]!.map(
                  (x) => JobQuotationResponce.fromJson(x),
                ),
              ),
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
    "siteVisitRequired": siteVisitRequired,
    "createdDate": createdDate?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedDate": modifiedDate,
    "mediaList": mediaList == null
        ? []
        : List<dynamic>.from(mediaList!.map((x) => x.toJson())),
    "distributions": distributions,
    "jobQuotationRequest": jobQuotationRequest == null
        ? []
        : List<dynamic>.from(jobQuotationRequest!.map((x) => x.toJson())),
    "jobQuotationResponce": jobQuotationResponce == null
        ? []
        : List<dynamic>.from(jobQuotationResponce!.map((x) => x.toJson())),
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
  String? status;
  int? quotationId;
  int? quotationResponseId;
  List<JobQuotationResponseItem>? jobQuotationResponseItems;
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
    this.quotationResponseId,
    this.jobQuotationResponseItems,
    this.statusId,
    this.hasQuotationResponse,
  });

  factory JobQuotationRequest.fromJson(Map<String, dynamic> json) =>
      JobQuotationRequest(
        jobId: json["jobId"],
        serviceId: json["serviceId"],
        toVendorId: json["toVendorId"],
        fromCustomerId: json["fromCustomerId"],
        active: json["active"],
        createdBy: json["createdBy"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        modifiedBy: json["modifiedBy"],
        modifiedDate: json["modifiedDate"],
        status: json["status"],
        quotationId: json["quotationId"],
        quotationResponseId: json["quotationResponseId"],
        jobQuotationResponseItems: json["jobQuotationResponseItems"] == null
            ? []
            : List<JobQuotationResponseItem>.from(
                json["jobQuotationResponseItems"]!.map(
                  (x) => JobQuotationResponseItem.fromJson(x),
                ),
              ),
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
    "quotationResponseId": quotationResponseId,
    "jobQuotationResponseItems": jobQuotationResponseItems == null
        ? []
        : List<dynamic>.from(jobQuotationResponseItems!.map((x) => x.toJson())),
    "statusId": statusId,
    "hasQuotationResponse": hasQuotationResponse,
  };
}

class JobQuotationResponce {
  int? jobId;
  int? quotationRequestId;
  int? serviceId;
  int? vendorId;
  String? quotationDetails;
  double? quotationAmount;
  double? serviceCharge;
  DateTime? startDate;
  DateTime? endDate;
  String? createdBy;
  DateTime? createdDate;
  String? status;
  int? quotationResponceId;
  List<JobQuotationResponseItem>? jobQuotationResponseItems;

  JobQuotationResponce({
    this.jobId,
    this.quotationRequestId,
    this.serviceId,
    this.vendorId,
    this.quotationDetails,
    this.quotationAmount,
    this.serviceCharge,
    this.startDate,
    this.endDate,
    this.createdBy,
    this.createdDate,
    this.status,
    this.quotationResponceId,
    this.jobQuotationResponseItems,
  });

  factory JobQuotationResponce.fromJson(Map<String, dynamic> json) =>
      JobQuotationResponce(
        jobId: json["jobId"],
        quotationRequestId: json["quotationRequestId"],
        serviceId: json["serviceId"],
        vendorId: json["vendorId"],
        quotationDetails: json["quotationDetails"],
        quotationAmount: json["quotationAmount"]?.toDouble(),
        serviceCharge: json["serviceCharge"]?.toDouble(),
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null
            ? null
            : DateTime.parse(json["endDate"]),
        createdBy: json["createdBy"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        status: json["status"],
        quotationResponceId: json["quotationResponceId"],
        jobQuotationResponseItems: json["jobQuotationResponseItems"] == null
            ? []
            : List<JobQuotationResponseItem>.from(
                json["jobQuotationResponseItems"].map(
                  (x) => JobQuotationResponseItem.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "quotationRequestId": quotationRequestId,
    "serviceId": serviceId,
    "vendorId": vendorId,
    "quotationDetails": quotationDetails,
    "quotationAmount": quotationAmount,
    "serviceCharge": serviceCharge,
    "startDate": startDate?.toIso8601String(),
    "endDate": endDate?.toIso8601String(),
    "createdBy": createdBy,
    "createdDate": createdDate?.toIso8601String(),
    "status": status,
    "quotationResponceId": quotationResponceId,
    "jobQuotationResponseItems": jobQuotationResponseItems == null
        ? []
        : List<dynamic>.from(jobQuotationResponseItems!.map((x) => x.toJson())),
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
    createdDate: json["createdDate"] == null
        ? null
        : DateTime.parse(json["createdDate"]),
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

class JobQuotationResponseItem {
  int? quotationResponceId;
  String? product;
  int? quantity;
  double? price;
  double? totalAmount;

  JobQuotationResponseItem({
    this.quotationResponceId,
    this.product,
    this.quantity,
    this.price,
    this.totalAmount,
  });

  factory JobQuotationResponseItem.fromJson(Map<String, dynamic> json) =>
      JobQuotationResponseItem(
        quotationResponceId: json["quotationResponceId"],
        product: json["product"],
        quantity: json["quantity"],
        price: json["price"],
        totalAmount: json["totalAmount"],
      );

  Map<String, dynamic> toJson() => {
    "quotationResponceId": quotationResponceId,
    "product": product,
    "quantity": quantity,
    "price": price,
    "totalAmount": totalAmount,
  };
}
