// To parse this JSON data, do
//
//     final updateUserResponse = updateUserResponseFromJson(jsonString);

import 'dart:convert';

UpdateUserResponse updateUserResponseFromJson(String str) => UpdateUserResponse.fromJson(json.decode(str));

String updateUserResponseToJson(UpdateUserResponse data) => json.encode(data.toJson());

class UpdateUserResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  UserData? data;

  UpdateUserResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) => UpdateUserResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? null : UserData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data?.toJson(),
  };
}

class UserData {
  int? customerId;
  int? typeId;
  String? type;
  String? name;
  String? mobile;
  dynamic landline;
  dynamic alternateContactNo;
  String? email;
  dynamic communityId;
  String? building;
  String? block;
  String? address;
  String? latitude;
  String? longitude;
  dynamic blacklisted;
  dynamic settlementPercentage;
  bool? deleted;
  bool? active;
  dynamic createdDate;
  String? createdBy;
  DateTime? modifiedDate;
  dynamic modifiedBy;
  String? userId;
  String? password;
  bool? loginEnable;
  String? customerType;
  dynamic image;

  UserData({
    this.customerId,
    this.typeId,
    this.type,
    this.name,
    this.mobile,
    this.landline,
    this.alternateContactNo,
    this.email,
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
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
    this.userId,
    this.password,
    this.loginEnable,
    this.customerType,
    this.image,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    customerId: json["customerId"],
    typeId: json["typeId"],
    type: json["type"],
    name: json["name"],
    mobile: json["mobile"],
    landline: json["landline"],
    alternateContactNo: json["alternateContactNo"],
    email: json["email"],
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
    createdDate: json["createdDate"],
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
    modifiedBy: json["modifiedBy"],
    userId: json["userId"],
    password: json["password"],
    loginEnable: json["loginEnable"],
    customerType: json["customerType"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "customerId": customerId,
    "typeId": typeId,
    "type": type,
    "name": name,
    "mobile": mobile,
    "landline": landline,
    "alternateContactNo": alternateContactNo,
    "email": email,
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
    "createdDate": createdDate,
    "createdBy": createdBy,
    "modifiedDate": modifiedDate?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "userId": userId,
    "password": password,
    "loginEnable": loginEnable,
    "customerType": customerType,
    "image": image,
  };
}
