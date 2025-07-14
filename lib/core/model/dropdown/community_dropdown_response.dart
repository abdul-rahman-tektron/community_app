// To parse this JSON data, do
//
//     final communityDropdownResponse = communityDropdownResponseFromJson(jsonString);

import 'dart:convert';

List<CommunityDropdownData> communityDropdownResponseFromJson(String str) => List<CommunityDropdownData>.from(json.decode(str).map((x) => CommunityDropdownData.fromJson(x)));

String communityDropdownResponseToJson(List<CommunityDropdownData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommunityDropdownData {
  int? communityId;
  String? name;
  bool? deleted;
  bool? active;
  DateTime? createdDate;
  String? createdBy;
  dynamic modifiedDate;
  dynamic modifiedBy;

  CommunityDropdownData({
    this.communityId,
    this.name,
    this.deleted,
    this.active,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
  });

  factory CommunityDropdownData.fromJson(Map<String, dynamic> json) => CommunityDropdownData(
    communityId: json["communityId"],
    name: json["name"],
    deleted: json["deleted"],
    active: json["active"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"],
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "communityId": communityId,
    "name": name,
    "deleted": deleted,
    "active": active,
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate,
    "modifiedBy": modifiedBy,
  };
}
