// To parse this JSON data, do
//
//     final jobStatusTrackingRequest = jobStatusTrackingRequestFromJson(jsonString);

import 'dart:convert';

JobStatusTrackingRequest jobStatusTrackingRequestFromJson(String str) => JobStatusTrackingRequest.fromJson(json.decode(str));

String jobStatusTrackingRequestToJson(JobStatusTrackingRequest data) => json.encode(data.toJson());

class JobStatusTrackingRequest {
  int? jobId;

  JobStatusTrackingRequest({
    this.jobId,
  });

  factory JobStatusTrackingRequest.fromJson(Map<String, dynamic> json) => JobStatusTrackingRequest(
    jobId: json["jobId"],
  );

  Map<String, dynamic> toJson() => {
    "jobId": jobId,
  };
}
