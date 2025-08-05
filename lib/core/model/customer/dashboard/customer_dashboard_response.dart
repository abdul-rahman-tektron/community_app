// To parse this JSON data, do
//
//     final customerDashboardResponse = customerDashboardResponseFromJson(jsonString);

import 'dart:convert';

CustomerDashboardResponse customerDashboardResponseFromJson(String str) => CustomerDashboardResponse.fromJson(json.decode(str));

String customerDashboardResponseToJson(CustomerDashboardResponse data) => json.encode(data.toJson());

class CustomerDashboardResponse {
  Jobstats? jobstats;
  List<dynamic>? promotionalcontent;

  CustomerDashboardResponse({
    this.jobstats,
    this.promotionalcontent,
  });

  factory CustomerDashboardResponse.fromJson(Map<String, dynamic> json) => CustomerDashboardResponse(
    jobstats: json["jobstats"] == null ? null : Jobstats.fromJson(json["jobstats"]),
    promotionalcontent: json["promotionalcontent"] == null ? [] : List<dynamic>.from(json["promotionalcontent"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "jobstats": jobstats?.toJson(),
    "promotionalcontent": promotionalcontent == null ? [] : List<dynamic>.from(promotionalcontent!.map((x) => x)),
  };
}

class Jobstats {
  int? ongoing;
  int? completed;

  Jobstats({
    this.ongoing,
    this.completed,
  });

  factory Jobstats.fromJson(Map<String, dynamic> json) => Jobstats(
    ongoing: json["ongoing"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "ongoing": ongoing,
    "completed": completed,
  };
}
