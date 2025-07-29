// To parse this JSON data, do
//
//     final vendorRegisterRequest = vendorRegisterRequestFromJson(jsonString);

import 'dart:convert';

VendorRegisterRequest vendorRegisterRequestFromJson(String str) => VendorRegisterRequest.fromJson(json.decode(str));

String vendorRegisterRequestToJson(VendorRegisterRequest data) => json.encode(data.toJson());

class VendorRegisterRequest {
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
  String? createdBy;
  String? userId;
  String? password;
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
    this.typeId = 1,
    this.type = "V",
    this.communityId = 3,
    this.customerType = "V",
    this.userId = "",
    this.createdBy = "system",

    DateTime? createdDate,
    DateTime? modifiedDate,
  });

  factory VendorRegisterRequest.fromJson(Map<String, dynamic> json) => VendorRegisterRequest(
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
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    createdBy: json["createdBy"],
    modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
    userId: json["userId"],
    password: json["password"],
    customerType: json["customerType"],
    bankDetail: json["bankDetail"] == null ? null : VendorBankDetail.fromJson(json["bankDetail"]),
    documents: json["documents"] == null ? [] : List<VendorDocumentDetails>.from(json["documents"]!.map((x) => VendorDocumentDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
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
    "createdBy": createdBy,
    "userId": userId,
    "password": password,
    "customerType": customerType,
    "bankDetail": bankDetail?.toJson(),
    "documents": documents == null ? [] : List<dynamic>.from(documents!.map((x) => x.toJson())),
  };
}

class VendorBankDetail {
  String? bankName;
  String? accountNumber;
  String? iban;
  String? swiftbic;
  String? bankBranch;
  String? address;

  VendorBankDetail({
    this.bankName,
    this.accountNumber,
    this.iban,
    this.swiftbic,
    this.bankBranch,
    this.address,
  });

  factory VendorBankDetail.fromJson(Map<String, dynamic> json) => VendorBankDetail(
    bankName: json["bankName"],
    accountNumber: json["accountNumber"],
    iban: json["iban"],
    swiftbic: json["swiftbic"],
    bankBranch: json["bankBranch"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName ?? "",
    "accountNumber": accountNumber ?? "",
    "iban": iban ?? "",
    "swiftbic": swiftbic ?? "",
    "bankBranch": bankBranch ?? "",
    "address": address ?? "",
  };
}

class VendorDocumentDetails {
  int? documentIdentity;
  String? documentType;
  DateTime? documentExpiryDate;
  String? documentFile;

  VendorDocumentDetails({
    this.documentIdentity,
    this.documentType,
    this.documentExpiryDate,
    this.documentFile,
  });

  factory VendorDocumentDetails.fromJson(Map<String, dynamic> json) => VendorDocumentDetails(
    documentIdentity: json["documentIdentity"],
    documentType: json["documentType"],
    documentExpiryDate: json["documentExpiryDate"] == null ? null : DateTime.parse(json["documentExpiryDate"]),
    documentFile: json["documentFile"],
  );

  Map<String, dynamic> toJson() => {
    "documentIdentity": documentIdentity ?? 1,
    "documentType": documentType ?? "",
    "documentExpiryDate": (documentExpiryDate ?? DateTime.now()).toIso8601String(),
    "documentFile": documentFile ?? "",
  };
}
