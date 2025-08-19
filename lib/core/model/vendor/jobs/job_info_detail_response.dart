import 'dart:convert';
import 'dart:typed_data';

JobInfoDetailResponse jobInfoDetailResponseFromJson(String str) =>
    JobInfoDetailResponse.fromJson(json.decode(str));

String jobInfoDetailResponseToJson(JobInfoDetailResponse data) =>
    json.encode(data.toJson());

class JobInfoDetailResponse {
  String? customerName;
  String? serviceName;
  String? phoneNumber;
  String? address;
  DateTime? expectedDate;
  String? priority;
  String? fileContent; // base64 string from API
  Uint8List? fileBytes; // decoded once & cached
  String? remarks;

  JobInfoDetailResponse({
    this.customerName,
    this.serviceName,
    this.phoneNumber,
    this.address,
    this.expectedDate,
    this.priority,
    this.fileContent,
    this.fileBytes,
    this.remarks,
  });

  factory JobInfoDetailResponse.fromJson(Map<String, dynamic> json) {
    final fileStr = json["fileContent"] as String?;
    return JobInfoDetailResponse(
      customerName: json["customerName"],
      serviceName: json["serviceName"],
      phoneNumber: json["phoneNumber"],
      address: json["address"],
      expectedDate: json["expectedDate"] == null
          ? null
          : DateTime.parse(json["expectedDate"]),
      priority: json["priority"],
      fileContent: fileStr,
      fileBytes: (fileStr != null && fileStr.isNotEmpty)
          ? base64Decode(fileStr)
          : null,
      remarks: json["remarks"],
    );
  }

  Map<String, dynamic> toJson() => {
    "customerName": customerName,
    "serviceName": serviceName,
    "phoneNumber": phoneNumber,
    "address": address,
    "expectedDate": expectedDate?.toIso8601String(),
    "priority": priority,
    "fileContent": fileContent,
    "remarks": remarks,
  };
}