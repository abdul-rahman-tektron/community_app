// To parse this JSON data, do
//
//     final siteVisitAssignEmployeeRequest = siteVisitAssignEmployeeRequestFromJson(jsonString);

import 'dart:convert';

SiteVisitAssignEmployeeRequest siteVisitAssignEmployeeRequestFromJson(String str) => SiteVisitAssignEmployeeRequest.fromJson(json.decode(str));

String siteVisitAssignEmployeeRequestToJson(SiteVisitAssignEmployeeRequest data) => json.encode(data.toJson());

class SiteVisitAssignEmployeeRequest {
  int? siteVisitId;
  List<AssignEmployeeList>? assignEmployeeList;

  SiteVisitAssignEmployeeRequest({
    this.siteVisitId,
    this.assignEmployeeList,
  });

  factory SiteVisitAssignEmployeeRequest.fromJson(Map<String, dynamic> json) => SiteVisitAssignEmployeeRequest(
    siteVisitId: json["siteVisitId"],
    assignEmployeeList: json["assignEmployeeList"] == null ? [] : List<AssignEmployeeList>.from(json["assignEmployeeList"]!.map((x) => AssignEmployeeList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "siteVisitId": siteVisitId,
    "assignEmployeeList": assignEmployeeList == null ? [] : List<dynamic>.from(assignEmployeeList!.map((x) => x.toJson())),
  };
}

class AssignEmployeeList {
  String? employeeName;
  String? employeePhoneNumber;
  String? emiratesIdPhoto;
  String? emiratesIdNumber;

  AssignEmployeeList({
    this.employeeName,
    this.employeePhoneNumber,
    this.emiratesIdPhoto,
    this.emiratesIdNumber,
  });

  factory AssignEmployeeList.fromJson(Map<String, dynamic> json) => AssignEmployeeList(
    employeeName: json["employeeName"],
    employeePhoneNumber: json["employeePhoneNumber"],
    emiratesIdPhoto: json["emiratesIdPhoto"],
    emiratesIdNumber: json["emiratesIdNumber"],
  );

  Map<String, dynamic> toJson() => {
    "employeeName": employeeName,
    "employeePhoneNumber": employeePhoneNumber,
    "emiratesIdPhoto": emiratesIdPhoto,
    "emiratesIdNumber": emiratesIdNumber,
  };
}
