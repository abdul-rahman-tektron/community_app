// To parse this JSON data, do
//
//     final updateUserRequest = updateUserRequestFromJson(jsonString);

import 'dart:convert';

UpdateUserRequest updateUserRequestFromJson(String str) => UpdateUserRequest.fromJson(json.decode(str));

String updateUserRequestToJson(UpdateUserRequest data) => json.encode(data.toJson());

class UpdateUserRequest {
  int? customerId;
  String? name;
  String? email;
  String? mobile;
  String? building;
  String? block;
  String? address;
  String? latitude;
  String? longitude;
  String? userId;
  String? password;
  String? createdBy;
  String? image;

  UpdateUserRequest({
    this.customerId,
    this.name,
    this.email,
    this.mobile,
    this.building,
    this.block,
    this.address,
    this.latitude,
    this.longitude,
    this.userId,
    this.password,
    this.createdBy,
    this.image,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) => UpdateUserRequest(
    customerId: json["customerId"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    building: json["building"],
    block: json["block"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    userId: json["userId"],
    password: json["password"],
    createdBy: json["createdBy"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "name": name,
    "email": email,
    "mobile": mobile,
    "building": building,
    "block": block,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "userId": userId,
    "password": password,
    "createdBy": createdBy,
    "image": image,
  };
}
