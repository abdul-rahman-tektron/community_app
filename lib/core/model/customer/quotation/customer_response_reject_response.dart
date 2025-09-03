import 'dart:convert';

CustomerResponseRejectResponse customerResponseRejectResponseFromJson(String str) => CustomerResponseRejectResponse.fromJson(json.decode(str));

String customerResponseRejectResponseToJson(CustomerResponseRejectResponse data) => json.encode(data.toJson());

class CustomerResponseRejectResponse {
  String? message;

  CustomerResponseRejectResponse({
    this.message,
  });

  factory CustomerResponseRejectResponse.fromJson(Map<String, dynamic> json) => CustomerResponseRejectResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}