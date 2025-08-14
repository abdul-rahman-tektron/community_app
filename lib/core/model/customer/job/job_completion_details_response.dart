// To parse this JSON data, do
//
//     final jobCompletionDetailsResponse = jobCompletionDetailsResponseFromJson(jsonString);

import 'dart:convert';

JobCompletionDetailsResponse jobCompletionDetailsResponseFromJson(String str) => JobCompletionDetailsResponse.fromJson(json.decode(str));

String jobCompletionDetailsResponseToJson(JobCompletionDetailsResponse data) => json.encode(data.toJson());

class JobCompletionDetailsResponse {
  String? notes;
  List<CompletionPhoto>? photos;

  JobCompletionDetailsResponse({
    this.notes,
    this.photos,
  });

  factory JobCompletionDetailsResponse.fromJson(Map<String, dynamic> json) => JobCompletionDetailsResponse(
    notes: json["notes"],
    photos: json["photos"] == null ? [] : List<CompletionPhoto>.from(json["photos"]!.map((x) => CompletionPhoto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "notes": notes,
    "photos": photos == null ? [] : List<dynamic>.from(photos!.map((x) => x.toJson())),
  };
}

class CompletionPhoto {
  String? beforePhotoUrl;
  String? afterPhotoUrl;
  bool? isBeforeVideo;
  bool? isAfterVideo;

  CompletionPhoto({
    this.beforePhotoUrl,
    this.afterPhotoUrl,
    this.isBeforeVideo,
    this.isAfterVideo,
  });

  factory CompletionPhoto.fromJson(Map<String, dynamic> json) => CompletionPhoto(
    beforePhotoUrl: json["beforePhotoUrl"],
    afterPhotoUrl: json["afterPhotoUrl"],
    isBeforeVideo: json["isBeforeVideo"],
    isAfterVideo: json["isAfterVideo"],
  );

  Map<String, dynamic> toJson() => {
    "beforePhotoUrl": beforePhotoUrl,
    "afterPhotoUrl": afterPhotoUrl,
    "isBeforeVideo": isBeforeVideo,
    "isAfterVideo": isAfterVideo,
  };
}
