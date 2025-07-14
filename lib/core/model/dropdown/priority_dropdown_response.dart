// To parse this JSON data, do
//
//     final serviceDropdownResponse = serviceDropdownResponseFromJson(jsonString);

import 'dart:convert';

List<PriorityDropdownData> serviceDropdownResponseFromJson(String str) => List<PriorityDropdownData>.from(json.decode(str).map((x) => PriorityDropdownData.fromJson(x)));

String serviceDropdownResponseToJson(List<PriorityDropdownData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PriorityDropdownData {
  int? priorityId;
  String? name;

  PriorityDropdownData({
    this.priorityId,
    this.name,
  });

  factory PriorityDropdownData.fromJson(Map<String, dynamic> json) => PriorityDropdownData(
    priorityId: json["priorityId"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "priorityId": priorityId,
    "name": name,
  };
}
