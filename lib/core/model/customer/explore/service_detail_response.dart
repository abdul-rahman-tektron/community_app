// To parse this JSON data, do
//
//     final serviceDetailResponse = serviceDetailResponseFromJson(jsonString);

import 'dart:convert';

ServiceDetailResponse serviceDetailResponseFromJson(String str) => ServiceDetailResponse.fromJson(json.decode(str));

String serviceDetailResponseToJson(ServiceDetailResponse data) => json.encode(data.toJson());

class ServiceDetailResponse {
  bool? success;
  String? message;
  String? uniqueId;
  DateTime? timestamp;
  ServiceDetailData? data;

  ServiceDetailResponse({
    this.success,
    this.message,
    this.uniqueId,
    this.timestamp,
    this.data,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) => ServiceDetailResponse(
    success: json["success"],
    message: json["message"],
    uniqueId: json["uniqueId"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    data: json["data"] == null ? null : ServiceDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "uniqueId": uniqueId,
    "timestamp": timestamp?.toIso8601String(),
    "data": data?.toJson(),
  };
}

class ServiceDetailData {
  int? vendorId;
  String? serviceName;
  String? serviceImage;
  List<ServiceDetailVendor>? vendors;
  List<ServiceDetailReview>? reviews;
  List<ServiceDetailReviewCount>? reviewCount;

  ServiceDetailData({
    this.vendorId,
    this.serviceName,
    this.serviceImage,
    this.vendors,
    this.reviews,
    this.reviewCount,
  });

  factory ServiceDetailData.fromJson(Map<String, dynamic> json) => ServiceDetailData(
    vendorId: json["vendorId"],
    serviceName: json["serviceName"],
    serviceImage: json["serviceImage"],
    vendors: json["vendors"] == null ? [] : List<ServiceDetailVendor>.from(json["vendors"]!.map((x) => ServiceDetailVendor.fromJson(x))),
    reviews: json["reviews"] == null ? [] : List<ServiceDetailReview>.from(json["reviews"]!.map((x) => ServiceDetailReview.fromJson(x))),
    reviewCount: json["reviewCount"] == null ? [] : List<ServiceDetailReviewCount>.from(json["reviewCount"]!.map((x) => ServiceDetailReviewCount.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "serviceName": serviceName,
    "serviceImage": serviceImage,
    "vendors": vendors == null ? [] : List<dynamic>.from(vendors!.map((x) => x.toJson())),
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
    "reviewCount": reviewCount == null ? [] : List<dynamic>.from(reviewCount!.map((x) => x.toJson())),
  };
}

class ServiceDetailReviewCount {
  int? rating;
  int? count;

  ServiceDetailReviewCount({
    this.rating,
    this.count,
  });

  factory ServiceDetailReviewCount.fromJson(Map<String, dynamic> json) => ServiceDetailReviewCount(
    rating: json["rating"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "rating": rating,
    "count": count,
  };
}

class ServiceDetailReview {
  int? jobId;
  String? customerName;
  String? customerImage;
  int? rating;
  String? feedback;
  DateTime? reviewDate;

  ServiceDetailReview({
    this.jobId,
    this.customerName,
    this.customerImage,
    this.rating,
    this.feedback,
    this.reviewDate,
  });

  factory ServiceDetailReview.fromJson(Map<String, dynamic> json) => ServiceDetailReview(
    jobId: json["jobId"],
    customerName: json["customerName"],
    customerImage: json["customerImage"],
    rating: json["rating"],
    feedback: json["feedback"],
    reviewDate: json["reviewDate"] == null ? null : DateTime.parse(json["reviewDate"]),
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
    "customerName": customerName,
    "customerImage": customerImage,
    "rating": rating,
    "feedback": feedback,
    "reviewDate": reviewDate?.toIso8601String(),
  };
}

class ServiceDetailVendor {
  int? vendorId;
  String? vendorName;
  String? vendorLogo;
  String? description;
  String? vendorEmail;
  String? address;
  double? totalRating;
  int? reviewCount;
  String? serviceName;
  List<ServiceDetailReview>? reviews;

  ServiceDetailVendor({
    this.vendorId,
    this.vendorName,
    this.vendorLogo,
    this.description,
    this.vendorEmail,
    this.address,
    this.totalRating,
    this.reviewCount,
    this.serviceName,
    this.reviews,
  });

  factory ServiceDetailVendor.fromJson(Map<String, dynamic> json) => ServiceDetailVendor(
    vendorId: json["vendorId"],
    vendorName: json["vendorName"],
    vendorLogo: json["vendorLogo"],
    description: json["description"],
    vendorEmail: json["vendorEmail"],
    address: json["address"],
    totalRating: json["totalRating"]?.toDouble(),
    reviewCount: json["reviewCount"],
    serviceName: json["serviceName"],
    reviews: json["reviews"] == null ? [] : List<ServiceDetailReview>.from(json["reviews"]!.map((x) => ServiceDetailReview.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "vendorName": vendorName,
    "vendorLogo": vendorLogo,
    "description": description,
    "vendorEmail": vendorEmail,
    "address": address,
    "totalRating": totalRating,
    "reviewCount": reviewCount,
    "serviceName": serviceName,
    "reviews": reviews == null ? [] : List<dynamic>.from(reviews!.map((x) => x.toJson())),
  };
}
