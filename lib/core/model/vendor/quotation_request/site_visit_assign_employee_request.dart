// To parse this JSON data, do
//
//     final siteVisitAssignEmployeeRequest = siteVisitAssignEmployeeRequestFromJson(jsonString);

import 'dart:convert';

SiteVisitAssignEmployeeRequest siteVisitAssignEmployeeRequestFromJson(String str) => SiteVisitAssignEmployeeRequest.fromJson(json.decode(str));

String siteVisitAssignEmployeeRequestToJson(SiteVisitAssignEmployeeRequest data) => json.encode(data.toJson());

class SiteVisitAssignEmployeeRequest {
  int? siteVisitId;
  int? customerId;
  int? jobId;
  List<AssignEmployeeList>? assignEmployeeList;

  SiteVisitAssignEmployeeRequest({
    this.siteVisitId,
    this.customerId,
    this.jobId,
    this.assignEmployeeList,
  });

  factory SiteVisitAssignEmployeeRequest.fromJson(Map<String, dynamic> json) => SiteVisitAssignEmployeeRequest(
    siteVisitId: json["siteVisitId"],
    customerId: json["customerId"],
    jobId: json["jobId"],
    assignEmployeeList: json["assignEmployeeList"] == null ? [] : List<AssignEmployeeList>.from(json["assignEmployeeList"]!.map((x) => AssignEmployeeList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "siteVisitId": siteVisitId,
    "customerId": customerId,
    "jobId": jobId,
    "assignEmployeeList": assignEmployeeList == null ? [] : List<dynamic>.from(assignEmployeeList!.map((x) => x.toJson())),
  };
}

class AssignEmployeeList {
  String? employeeName;
  String? employeePhoneNumber;
  String? emiratesIdPhoto;
  String? emiratesIdNumber;
  String? employeeEmail;

  AssignEmployeeList({
    this.employeeName,
    this.employeePhoneNumber,
    this.emiratesIdPhoto,
    this.emiratesIdNumber,
    this.employeeEmail = "abdul.rahman@tektronixllc.ae",
  });

  factory AssignEmployeeList.fromJson(Map<String, dynamic> json) => AssignEmployeeList(
    employeeName: json["employeeName"],
    employeePhoneNumber: json["employeePhoneNumber"],
    emiratesIdPhoto: json["emiratesIdPhoto"],
    emiratesIdNumber: json["emiratesIdNumber"],
    employeeEmail: json["employeeEmail"],
  );

  Map<String, dynamic> toJson() => {
    "employeeName": employeeName,
    "employeePhoneNumber": employeePhoneNumber,
    "emiratesIdPhoto": emiratesIdPhoto,
    "emiratesIdNumber": emiratesIdNumber,
    "employeeEmail": employeeEmail,
  };
}
