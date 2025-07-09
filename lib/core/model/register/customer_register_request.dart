import 'dart:convert';

CustomerRegisterRequest customerRegisterRequestFromJson(String str) => CustomerRegisterRequest.fromJson(json.decode(str));

String customerRegisterRequestToJson(CustomerRegisterRequest data) => json.encode(data.toJson());

class CustomerRegisterRequest {
  int typeId;
  String type;
  String? name;
  String? mobile;
  String? email;
  int communityId;
  String? building;
  String? block;
  String? address;
  String? latitude;
  String? longitude;
  String createdBy;
  String userId;
  String? password;
  String? customerType;

  CustomerRegisterRequest({
    this.name,
    this.mobile,
    this.email,
    this.password,
    this.customerType = "C",
    this.address,
    this.building,
    this.block,
    this.latitude,
    this.longitude,
    // Defaults
    this.typeId = 1,
    this.type = "C",
    this.communityId = 3,
    this.createdBy = "system",
    this.userId = "",
  });

  factory CustomerRegisterRequest.fromJson(Map<String, dynamic> json) => CustomerRegisterRequest(
    typeId: json["typeId"] ?? 1,
    type: json["type"] ?? "C",
    name: json["name"],
    mobile: json["mobile"],
    email: json["email"],
    communityId: json["communityId"] ?? 0,
    building: json["building"],
    block: json["block"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdBy: json["createdBy"] ?? "system",
    userId: json["userId"] ?? "",
    password: json["password"],
    customerType: json["customerType"],
  );

  Map<String, dynamic> toJson() => {
    "typeId": typeId,
    "type": type,
    "name": name,
    "mobile": mobile,
    "email": email,
    "communityId": communityId,
    "building": building,
    "block": block,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "createdBy": createdBy,
    "userId": userId,
    "password": password,
    "customerType": customerType,
  };
}
