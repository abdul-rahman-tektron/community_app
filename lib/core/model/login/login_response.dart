// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String? email;
  String? token;
  int? customerId;
  int? typeId;
  String? type;
  dynamic name;
  dynamic mobile;
  dynamic landline;
  dynamic alternateContactNo;
  dynamic communityId;
  dynamic building;
  dynamic block;
  dynamic address;
  dynamic latitude;
  dynamic longitude;
  dynamic blacklisted;
  dynamic settlementPercentage;
  bool? deleted;
  bool? active;
  dynamic userId;
  dynamic password;
  bool? loginEnable;
  String? customerType;

  LoginResponse({
    this.email,
    this.token,
    this.customerId,
    this.typeId,
    this.type,
    this.name,
    this.mobile,
    this.landline,
    this.alternateContactNo,
    this.communityId,
    this.building,
    this.block,
    this.address,
    this.latitude,
    this.longitude,
    this.blacklisted,
    this.settlementPercentage,
    this.deleted,
    this.active,
    this.userId,
    this.password,
    this.loginEnable,
    this.customerType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    email: json["email"],
    token: json["token"],
    customerId: json["customerId"],
    typeId: json["typeId"],
    type: json["type"],
    name: json["name"],
    mobile: json["mobile"],
    landline: json["landline"],
    alternateContactNo: json["alternateContactNo"],
    communityId: json["communityId"],
    building: json["building"],
    block: json["block"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    blacklisted: json["blacklisted"],
    settlementPercentage: json["settlementPercentage"],
    deleted: json["deleted"],
    active: json["active"],
    userId: json["userId"],
    password: json["password"],
    loginEnable: json["loginEnable"],
    customerType: json["customerType"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "token": token,
    "customerId": customerId,
    "typeId": typeId,
    "type": type,
    "name": name,
    "mobile": mobile,
    "landline": landline,
    "alternateContactNo": alternateContactNo,
    "communityId": communityId,
    "building": building,
    "block": block,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "blacklisted": blacklisted,
    "settlementPercentage": settlementPercentage,
    "deleted": deleted,
    "active": active,
    "userId": userId,
    "password": password,
    "loginEnable": loginEnable,
    "customerType": customerType,
  };
}
