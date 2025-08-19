// To parse this JSON data, do
//
//     final deleteAccountRequest = deleteAccountRequestFromJson(jsonString);

import 'dart:convert';

DeleteAccountRequest deleteAccountRequestFromJson(String str) => DeleteAccountRequest.fromJson(json.decode(str));

String deleteAccountRequestToJson(DeleteAccountRequest data) => json.encode(data.toJson());

class DeleteAccountRequest {
  int? customerId;
  String? modifiedBy;

  DeleteAccountRequest({
    this.customerId,
    this.modifiedBy,
  });

  factory DeleteAccountRequest.fromJson(Map<String, dynamic> json) => DeleteAccountRequest(
    customerId: json["customerId"],
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "modifiedBy": modifiedBy,
  };
}
