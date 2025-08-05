// To parse this JSON data, do
//
//     final vendorDashboardResponse = vendorDashboardResponseFromJson(jsonString);

import 'dart:convert';

VendorDashboardResponse vendorDashboardResponseFromJson(String str) => VendorDashboardResponse.fromJson(json.decode(str));

String vendorDashboardResponseToJson(VendorDashboardResponse data) => json.encode(data.toJson());

class VendorDashboardResponse {
  dynamic serviceMaster;
  List<dynamic>? documents;
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
    documents: json["documents"] == null ? [] : List<dynamic>.from(json["documents"]!.map((x) => x)),
    stats: json["stats"] == null ? null : Stats.fromJson(json["stats"]),
    jobStatusCounts: json["jobStatusCounts"] == null ? [] : List<dynamic>.from(json["jobStatusCounts"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "serviceMaster": serviceMaster,
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x)),
    "stats": stats?.toJson(),
    "jobStatusCounts": jobStatusCounts == null ? [] : List<dynamic>.from(jobStatusCounts!.map((x) => x)),
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
