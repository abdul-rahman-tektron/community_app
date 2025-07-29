// To parse this JSON data, do
//
//     final serviceDropdownResponse = serviceDropdownResponseFromJson(jsonString);

import 'dart:convert';

List<ServiceDropdownData> serviceDropdownResponseFromJson(String str) => List<ServiceDropdownData>.from(json.decode(str).map((x) => ServiceDropdownData.fromJson(x)));

String serviceDropdownResponseToJson(List<ServiceDropdownData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ServiceDropdownData {
  int? serviceId;
  String? serviceName;
  bool? deleted;
  bool? active;
  DateTime? createdDate;
  String? createdBy;
  dynamic modifiedDate;
  dynamic modifiedBy;

  ServiceDropdownData({
    this.serviceId,
    this.serviceName,
    this.deleted,
    this.active,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
  });

  factory ServiceDropdownData.fromJson(Map<String, dynamic> json) => ServiceDropdownData(
    serviceId: json["serviceId"],
    serviceName: json["serviceName"],
    deleted: json["deleted"],
    active: json["active"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"],
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "serviceId": serviceId,
    "serviceName": serviceName,
    "deleted": deleted,
    "active": active,
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate,
    "modifiedBy": modifiedBy,
  };
}
