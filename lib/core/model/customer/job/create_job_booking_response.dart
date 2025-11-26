// job_booking_response.dart
import 'dart:convert';
import 'package:Xception/core/model/customer/quotation/customer_response_response.dart' show EmailPreview;
// ^ reuse the same EmailPreview class you already have

JobBookingResponse jobBookingResponseFromJson(String str) => JobBookingResponse.fromJson(json.decode(str));

class JobBookingResponse {
  String? message;
  EmailPreview? emailPreview;

  JobBookingResponse({this.message, this.emailPreview});

  factory JobBookingResponse.fromJson(Map<String, dynamic> json) => JobBookingResponse(
    message: json["message"],
    emailPreview: json["emailPreview"] == null ? null : EmailPreview.fromJson(json["emailPreview"]),
  );
}