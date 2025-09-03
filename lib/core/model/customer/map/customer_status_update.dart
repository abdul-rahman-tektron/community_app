// To parse this JSON data, do
//
//     final customerStatusUpdate = customerStatusUpdateFromJson(jsonString);

import 'dart:convert';

List<CustomerStatusUpdate> customerStatusUpdateFromJson(String str) => List<CustomerStatusUpdate>.from(json.decode(str).map((x) => CustomerStatusUpdate.fromJson(x)));

String customerStatusUpdateToJson(List<CustomerStatusUpdate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomerStatusUpdate {
  int? statusId;
  String? status;
  int? progressPercent;
  String? category;
  String? description;

  CustomerStatusUpdate({
    this.statusId,
    this.status,
    this.progressPercent,
    this.category,
    this.description,
  });

  factory CustomerStatusUpdate.fromJson(Map<String, dynamic> json) => CustomerStatusUpdate(
    statusId: json["statusId"],
    status: json["status"],
    progressPercent: json["progressPercent"],
    category: json["category"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "statusId": statusId,
    "status": status,
    "progressPercent": progressPercent,
    "category": category,
    "description": description,
  };
}
