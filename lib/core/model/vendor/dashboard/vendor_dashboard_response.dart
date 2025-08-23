// To parse this JSON data, do
//
//     final vendorDashboardResponse = vendorDashboardResponseFromJson(jsonString);

import 'dart:convert';

VendorDashboardResponse vendorDashboardResponseFromJson(String str) => VendorDashboardResponse.fromJson(json.decode(str));

String vendorDashboardResponseToJson(VendorDashboardResponse data) => json.encode(data.toJson());

class VendorDashboardResponse {
  dynamic serviceMaster;
  List<Document>? documents;
  Stats? stats;
  List<dynamic>? jobStatusCounts;

  VendorDashboardResponse({
    this.serviceMaster,
    this.documents,
    this.stats,
    this.jobStatusCounts,
  });

  factory VendorDashboardResponse.fromJson(Map<String, dynamic> json) => VendorDashboardResponse(
    serviceMaster: json["serviceMaster"],
    documents: json["documents"] == null ? [] : List<Document>.from(json["documents"]!.map((x) => Document.fromJson(x))),
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
    jobStatusCounts: json["jobStatusCounts"] == null ? [] : List<dynamic>.from(json["jobStatusCounts"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "serviceMaster": serviceMaster,
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
    "stats": stats?.toJson(),
    "jobStatusCounts": jobStatusCounts == null ? [] : List<dynamic>.from(jobStatusCounts!.map((x) => x)),
  };
}

class Document {
  dynamic documentIdentity;
  int? vendorId;
  int? documentTypeId;
  dynamic documentType;
  String? documentNumber;
  DateTime? documentExpiryDate;
  dynamic documentFile;
  bool? active;
  bool? deleted;
  DateTime? createdDate;
  String? createdBy;
  dynamic modifiedDate;
  dynamic modifiedBy;

  Document({
    this.documentIdentity,
    this.vendorId,
    this.documentTypeId,
    this.documentType,
    this.documentNumber,
    this.documentExpiryDate,
    this.documentFile,
    this.active,
    this.deleted,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
    documentIdentity: json["documentIdentity"],
    vendorId: json["vendorId"],
    documentTypeId: json["documentTypeId"],
    documentType: json["documentType"],
    documentNumber: json["documentNumber"],
    documentExpiryDate: json["documentExpiryDate"] == null ? null : DateTime.parse(json["documentExpiryDate"]),
    documentFile: json["documentFile"],
    active: json["active"],
    deleted: json["deleted"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"],
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "documentIdentity": documentIdentity,
    "vendorId": vendorId,
    "documentTypeId": documentTypeId,
    "documentType": documentType,
    "documentNumber": documentNumber,
    "documentExpiryDate": documentExpiryDate?.toIso8601String(),
    "documentFile": documentFile,
    "active": active,
    "deleted": deleted,
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate,
    "modifiedBy": modifiedBy,
  };
}


class Stats {
  int? pending;
  int? accepted;
  int? rejected;
  int? newRequest;
  int? awaitingQuotation;
  int? inProgress;
  int? pendingPayment;

  Stats({
    this.pending,
    this.accepted,
    this.rejected,
    this.newRequest,
    this.awaitingQuotation,
    this.inProgress,
    this.pendingPayment,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
    pending: json["pending"],
    accepted: json["accepted"],
    rejected: json["rejected"],
    newRequest: json["newRequest"],
    awaitingQuotation: json["awaitingQuotation"],
    inProgress: json["inProgress"],
    pendingPayment: json["pendingPayment"],
  );

  Map<String, dynamic> toJson() => {
    "pending": pending,
    "accepted": accepted,
    "rejected": rejected,
    "newRequest": newRequest,
    "awaitingQuotation": awaitingQuotation,
    "inProgress": inProgress,
    "pendingPayment": pendingPayment,
  };
}
