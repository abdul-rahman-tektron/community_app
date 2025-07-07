// To parse this JSON data, do
//
//     final vendorRegisterRequest = vendorRegisterRequestFromJson(jsonString);

import 'dart:convert';

VendorRegisterRequest vendorRegisterRequestFromJson(String str) => VendorRegisterRequest.fromJson(json.decode(str));

String vendorRegisterRequestToJson(VendorRegisterRequest data) => json.encode(data.toJson());

class VendorRegisterRequest {
  int? customerId;
  int? typeId;
  String? type;
  String? name;
  String? mobile;
  String? landline;
  String? alternateContactNo;
  String? email;
  int? communityId;
  String? building;
  String? block;
  String? address;
  String? latitude;
  String? longitude;
  bool? blacklisted;
  double? settlementPercentage;
  bool? deleted;
  bool? active;
  DateTime? createdDate;
  String? createdBy;
  DateTime? modifiedDate;
  String? modifiedBy;
  String? userId;
  String? password;
  bool? loginEnable;
  String? customerType;
  VendorBankDetail? bankDetail;
  List<VendorDocumentDetails>? documents;

  VendorRegisterRequest({
    this.name,
    this.mobile,
    this.landline = "093978837432",
    this.alternateContactNo = "3267823674",
    this.email,
    this.password,
    this.address,
    this.building,
    this.block,
    this.latitude,
    this.longitude,
    this.bankDetail,
    this.documents,
    // Defaults
    this.customerId = 0,
    this.typeId = 1,
    this.type = "V",
    this.communityId = 3,
    this.blacklisted = false,
    this.settlementPercentage = 0.0,
    this.deleted = false,
    this.active = true,
    this.customerType = "V",
    this.userId = "",
    this.loginEnable = true,
    this.createdBy = "system",
    this.modifiedBy = "system",
    DateTime? createdDate,
    DateTime? modifiedDate,
  })  : createdDate = createdDate ?? DateTime.now(),
        modifiedDate = modifiedDate ?? DateTime.now();

  factory VendorRegisterRequest.fromJson(Map<String, dynamic> json) => VendorRegisterRequest(
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
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
    modifiedBy: json["modifiedBy"],
    userId: json["userId"],
    password: json["password"],
    loginEnable: json["loginEnable"],
    customerType: json["customerType"],
    bankDetail: json["bankDetail"] == null ? null : VendorBankDetail.fromJson(json["bankDetail"]),
    documents: json["documents"] == null ? [] : List<VendorDocumentDetails>.from(json["documents"]!.map((x) => VendorDocumentDetails.fromJson(x))),
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
    "createdDate": createdDate?.toIso8601String(),
    "createdBy": createdBy,
    "modifiedDate": modifiedDate?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "userId": userId,
    "password": password,
    "loginEnable": loginEnable,
    "customerType": customerType,
    "bankDetail": bankDetail?.toJson(),
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
  };
}

class VendorBankDetail {
  int? iIdentity;
  int? vendorId;
  String? bankName;
  String? accountNumber;
  String? iban;
  String? swiftbic;
  String? bankBranch;
  String? address;
  bool? active;
  bool? deleted;
  DateTime? createdDate;
  String? createdBy;
  DateTime? modifiedDate;
  String? modifiedBy;

  VendorBankDetail({
    this.iIdentity,
    this.vendorId,
    this.bankName,
    this.accountNumber,
    this.iban,
    this.swiftbic,
    this.bankBranch,
    this.address,
    this.active,
    this.deleted,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
  });

  factory VendorBankDetail.fromJson(Map<String, dynamic> json) => VendorBankDetail(
    iIdentity: json["iIdentity"],
    vendorId: json["vendorId"],
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    iban: json["iban"],
    swiftbic: json["swiftbic"],
    bankBranch: json["bankBranch"],
    address: json["address"],
    active: json["active"],
    deleted: json["deleted"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "iIdentity": iIdentity ?? 1,
    "vendorId": vendorId ?? 1,
    "bankName": bankName ?? "",
    "accountNumber": accountNumber ?? "",
    "iban": iban ?? "",
    "swiftbic": swiftbic ?? "",
    "bankBranch": bankBranch ?? "",
    "address": address ?? "",
    "active": active ?? true,
    "deleted": deleted ?? false,
    "createdDate": (createdDate ?? DateTime.now()).toIso8601String(),
    "createdBy": createdBy ?? "system",
    "modifiedDate": (modifiedDate ?? DateTime.now()).toIso8601String(),
    "modifiedBy": modifiedBy ?? "system",
  };
}

class VendorDocumentDetails {
  int? documentIdentity;
  int? vendorId;
  String? documentType;
  DateTime? documentExpiryDate;
  String? documentFile;
  bool? active;
  bool? deleted;
  DateTime? createdDate;
  String? createdBy;
  DateTime? modifiedDate;
  String? modifiedBy;

  VendorDocumentDetails({
    this.documentIdentity,
    this.vendorId,
    this.documentType,
    this.documentExpiryDate,
    this.documentFile,
    this.active,
    this.deleted,
    this.createdDate,
    this.createdBy,
    this.modifiedDate,
    this.modifiedBy,
  });

  factory VendorDocumentDetails.fromJson(Map<String, dynamic> json) => VendorDocumentDetails(
    documentIdentity: json["documentIdentity"],
    vendorId: json["vendorId"],
    documentType: json["documentType"],
    documentExpiryDate: json["documentExpiryDate"] == null ? null : DateTime.parse(json["documentExpiryDate"]),
    documentFile: json["documentFile"],
    active: json["active"],
    deleted: json["deleted"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
    modifiedBy: json["modifiedBy"],
  );

  Map<String, dynamic> toJson() => {
    "documentIdentity": documentIdentity ?? 1,
    "vendorId": vendorId ?? 1,
    "documentType": documentType ?? "",
    "documentExpiryDate": (documentExpiryDate ?? DateTime.now()).toIso8601String(),
    "documentFile": documentFile ?? "",
    "active": active ?? true,
    "deleted": deleted ?? false,
    "createdDate": (createdDate ?? DateTime.now()).toIso8601String(),
    "createdBy": createdBy ?? "system",
    "modifiedDate": (modifiedDate ?? DateTime.now()).toIso8601String(),
    "modifiedBy": modifiedBy ?? "system",
  };
}
