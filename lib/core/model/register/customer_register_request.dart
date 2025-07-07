import 'dart:convert';

CustomerRegisterRequest customerRegisterRequestFromJson(String str) => CustomerRegisterRequest.fromJson(json.decode(str));

String customerRegisterRequestToJson(CustomerRegisterRequest data) => json.encode(data.toJson());

class CustomerRegisterRequest {
  int customerId;
  int typeId;
  String type;
  String? name;
  String? mobile;
  String? landline;
  String? alternateContactNo;
  String? email;
  int communityId;
  String? building;
  String? block;
  String? address;
  String? latitude;
  String? longitude;
  bool blacklisted;
  double settlementPercentage;
  bool deleted;
  bool active;
  DateTime createdDate;
  String createdBy;
  DateTime modifiedDate;
  String modifiedBy;
  String userId;
  String? password;
  bool loginEnable;
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
    this.customerId = 0,
    this.typeId = 1,
    this.type = "C",
    this.landline = "093978837432",
    this.alternateContactNo = "3267823674",
    this.communityId = 3,
    this.blacklisted = false,
    this.settlementPercentage = 0.0,
    this.deleted = false,
    this.active = true,
    DateTime? createdDate,
    this.createdBy = "system",
    DateTime? modifiedDate,
    this.modifiedBy = "system",
    this.userId = "",
    this.loginEnable = true,
  })  : createdDate = createdDate ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

  factory CustomerRegisterRequest.fromJson(Map<String, dynamic> json) => CustomerRegisterRequest(
    customerId: json["customerId"] ?? 0,
    typeId: json["typeId"] ?? 1,
    type: json["type"] ?? "C",
    name: json["name"],
    mobile: json["mobile"],
    landline: json["landline"] ?? "",
    alternateContactNo: json["alternateContactNo"] ?? "",
    email: json["email"],
    communityId: json["communityId"] ?? 0,
    building: json["building"],
    block: json["block"],
    address: json["address"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    blacklisted: json["blacklisted"] ?? false,
    settlementPercentage: (json["settlementPercentage"] ?? 0).toDouble(),
    deleted: json["deleted"] ?? false,
    active: json["active"] ?? true,
    createdDate: json["createdDate"] == null ? DateTime.now() : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"] ?? "system",
    modifiedDate: json["modifiedDate"] == null ? DateTime.now() : DateTime.parse(json["modifiedDate"]),
    modifiedBy: json["modifiedBy"] ?? "system",
    userId: json["userId"] ?? "",
    password: json["password"],
    loginEnable: json["loginEnable"] ?? true,
    customerType: json["customerType"],
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
    "createdDate": createdDate.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate.toIso8601String(),
    "modifiedBy": modifiedBy,
    "userId": userId,
    "password": password,
    "loginEnable": loginEnable,
    "customerType": customerType,
  };
}
