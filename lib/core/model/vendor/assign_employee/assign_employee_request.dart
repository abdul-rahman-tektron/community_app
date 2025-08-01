// To parse this JSON data, do
//
//     final assignEmployeeRequest = assignEmployeeRequestFromJson(jsonString);

import 'dart:convert';

AssignEmployeeRequest assignEmployeeRequestFromJson(String str) => AssignEmployeeRequest.fromJson(json.decode(str));

String assignEmployeeRequestToJson(AssignEmployeeRequest data) => json.encode(data.toJson());

class AssignEmployeeRequest {
  int? jobId;
  int? customerId;
  List<AssignEmployeeList>? assignEmployeeList;

  AssignEmployeeRequest({
    this.jobId,
    this.customerId,
    this.assignEmployeeList,
  });

  factory AssignEmployeeRequest.fromJson(Map<String, dynamic> json) => AssignEmployeeRequest(
    jobId: json["jobId"],
    customerId: json["customerId"],
    assignEmployeeList: json["assignEmployeeList"] == null ? [] : List<AssignEmployeeList>.from(json["assignEmployeeList"]!.map((x) => AssignEmployeeList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "customerId": customerId,
    "assignEmployeeList": assignEmployeeList == null ? [] : List<dynamic>.from(assignEmployeeList!.map((x) => x.toJson())),
  };
}

class AssignEmployeeList {
  String? employeeName;
  String? employeePhoneNumber;
  String? emiratesIdPhoto;

  AssignEmployeeList({
    this.employeeName,
    this.employeePhoneNumber,
    this.emiratesIdPhoto,
  });

  factory AssignEmployeeList.fromJson(Map<String, dynamic> json) => AssignEmployeeList(
    employeeName: json["employeeName"],
    employeePhoneNumber: json["employeePhoneNumber"],
    emiratesIdPhoto: json["emiratesIdPhoto"],
  );

  Map<String, dynamic> toJson() => {
    "employeeName": employeeName,
    "employeePhoneNumber": employeePhoneNumber,
    "emiratesIdPhoto": emiratesIdPhoto,
  };
}
