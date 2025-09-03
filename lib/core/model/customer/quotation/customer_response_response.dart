// To parse this JSON data, do
//
//     final customerResponse = customerResponseFromJson(jsonString);

import 'dart:convert';

CustomerResponse customerResponseFromJson(String str) => CustomerResponse.fromJson(json.decode(str));

String customerResponseToJson(CustomerResponse data) => json.encode(data.toJson());

class CustomerResponse {
  String? message;
  EmailPreview? emailPreview;

  CustomerResponse({
    this.message,
    this.emailPreview,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) => CustomerResponse(
    message: json["message"],
    emailPreview: json["emailPreview"] == null ? null : EmailPreview.fromJson(json["emailPreview"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "emailPreview": emailPreview?.toJson(),
  };
}

class EmailPreview {
  String? from;
  List<String>? to;
  List<String>? cc;
  String? subject;
  String? body;

  EmailPreview({
    this.from,
    this.to,
    this.cc,
    this.subject,
    this.body,
  });

  factory EmailPreview.fromJson(Map<String, dynamic> json) => EmailPreview(
    from: json["from"],
    to: json["to"] == null ? [] : List<String>.from(json["to"]!.map((x) => x)),
    cc: json["cc"] == null ? [] : List<String>.from(json["cc"]!.map((x) => x)),
    subject: json["subject"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "from": from,
    "to": to == null ? [] : List<dynamic>.from(to!.map((x) => x)),
    "cc": cc == null ? [] : List<dynamic>.from(cc!.map((x) => x)),
    "subject": subject,
    "body": body,
  };
}
