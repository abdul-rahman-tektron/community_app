import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/user/customer_id_request.dart';
import 'package:community_app/core/model/customer/job/customer_history_detail_request.dart';
import 'package:community_app/core/model/customer/job/customer_history_detail_response.dart';
import 'package:community_app/core/model/customer/job/customer_history_list_response.dart';
import 'package:community_app/core/model/customer/job/job_completion_details_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/job_status_tracking_request.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/job_status_tracking_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/jobs_status_response.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/model/customer/job/new_job_request.dart';
import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/core/model/customer/job/update_customer_completion_request.dart';
import 'package:community_app/core/model/customer/quotation/customer_response_reject_response.dart';
import 'package:community_app/core/model/customer/quotation/customer_response_request.dart';
import 'package:community_app/core/model/customer/quotation/customer_response_response.dart';
import 'package:community_app/core/model/customer/top_vendors/top_vendors_response.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/res/api_constants.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:dio/dio.dart';

class CustomerJobsRepository extends BaseRepository {
  CustomerJobsRepository._internal();
  static final instance = CustomerJobsRepository._internal();

  /// POST: /Job/CreateJob
  /// Purpose: Creates a new job request for the customer
  Future<Object?> apiNewJob(CreateJobRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCreateJob,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final commonResponse = commonResponseFromJson(jsonEncode(response?.data));
      return commonResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  /// GET: Google Directions API
  /// Purpose: Fetches route directions between two points with live traffic data
  Future<Map<String, dynamic>> getRouteWithTraffic({
    required String origin,
    required String destination,
  }) async {
    final url = 'https://maps.googleapis.com/maps/api/directions/json';
    final params = {
      'origin': origin,
      'destination': destination,
      'departure_time': 'now',
      'key': ApiConstants.apiKey,
    };

    try {
      final response = await Dio().get(url, queryParameters: params);

      if (response.statusCode == HttpStatus.ok && response.data != null) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw ErrorResponse.fromJson(response.data ?? {});
      }
    } catch (e) {
      rethrow; // Let the caller handle the error
    }
  }

  /// GET: /Vendor/GetAllVendorsforService/{serviceId}
  /// Purpose: Fetches a list of top vendors providing a specific service
  Future<Object?> apiTopVendorList(String serviceId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathTopVendor,
      queryParam: serviceId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final topVendorResponse = topVendorResponseFromJson(jsonEncode(response?.data));
      return topVendorResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  /// GET: /Job/GetCustomerOngoingJobs/{customerId}
  /// Purpose: Fetches the list of ongoing jobs assigned to a customer
  Future<Object?> apiGetCustomerOngoingJobs(String customerId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathCustomerOngoingJobs,
      queryParam: customerId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final ongoingJobAssignedResponse = customerOngoingJobsResponseFromJson(jsonEncode(response?.data));
      return ongoingJobAssignedResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiUpdateCustomerCompletion(UpdateCustomerCompletionRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathUpdateCustomerCompletion,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final commonResponse = commonResponseFromJson(jsonEncode(response?.data));
      return commonResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiJobCompletionDetails(String jobId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathJobCompletionDetails,
      queryParam: jobId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final jobCompletionDetailsResponse = jobCompletionDetailsResponseFromJson(jsonEncode(response?.data));
      return jobCompletionDetailsResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiJobStatusTracking(JobStatusTrackingRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathJobStatusTracking,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final jobStatusTrackingResponse = jobStatusTrackingResponseFromJson(jsonEncode(response?.data));
      return jobStatusTrackingResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiJobStatus() async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathJobStatus,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final jobStatusResponse = jobStatusResponseFromJson(jsonEncode(response?.data));
      return jobStatusResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiCustomerHistoryList(CustomerIdRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCustomerHistoryList,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final customerHistoryListResponse = customerHistoryListResponseFromJson(jsonEncode(response?.data));
      return customerHistoryListResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiCustomerHistoryDetails(CustomerHistoryDetailRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCustomerHistoryDetail,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final customerHistoryDetailResponse = customerHistoryDetailResponseFromJson(jsonEncode(response?.data));
      return customerHistoryDetailResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiSiteVisitCustomerResponse(CustomerResponseRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathSiteVisitCustomerResponse,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final data = response?.data;

      if (data["emailPreview"] != null) {
        return customerResponseFromJson(jsonEncode(data));
      } else {
        return customerResponseRejectResponseFromJson(jsonEncode(data));
      }
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }
}
