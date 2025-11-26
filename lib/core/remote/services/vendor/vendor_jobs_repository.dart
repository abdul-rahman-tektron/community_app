import 'dart:convert';
import 'dart:io';

import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/common/error/error_response.dart';
import 'package:Xception/core/model/common/jobs/ongoing_jobs_response.dart';
import 'package:Xception/core/model/common/user/customer_id_request.dart';
import 'package:Xception/core/model/customer/job/customer_history_detail_request.dart';
import 'package:Xception/core/model/customer/job/customer_history_detail_response.dart';
import 'package:Xception/core/model/customer/job/job_completion_request.dart';
import 'package:Xception/core/model/vendor/assign_employee/assign_employee_request.dart';
import 'package:Xception/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';
import 'package:Xception/core/model/vendor/jobs/vendor_history_detail_request.dart';
import 'package:Xception/core/model/vendor/jobs/vendor_history_detail_response.dart';
import 'package:Xception/core/model/vendor/jobs/vendor_history_list.dart';
import 'package:Xception/core/remote/network/api_url.dart';
import 'package:Xception/core/remote/network/base_repository.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/storage/secure_storage.dart';

class VendorJobsRepository extends BaseRepository {
  VendorJobsRepository._internal();
  static final instance = VendorJobsRepository._internal();

  /// POST: /Job/AssignEmployees
  /// Purpose: Assigns employees to a specific job request
  Future<Object?> apiAssignEmployee(AssignEmployeeRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathAssignEmployees,
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

  /// POST: /Job/JobCompletion
  /// Purpose: Marks a job as completed and uploads before/after photos (if provided)
  Future<Object?> apiJobCompletion(JobCompletionRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathJobCompletion,
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

  /// GET: /Job/GetVendorJobs/{vendorId}
  /// Purpose: Fetches all jobs associated with a vendor
  Future<Object?> apiGetVendorJobs(String vendorId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathVendorJobs,
      queryParam: vendorId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final ongoingJobsResponse = ongoingJobsResponseFromJson(jsonEncode(response?.data));
      return ongoingJobsResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  /// GET: /Job/GetVendorOngoingJobs/{vendorId}
  /// Purpose: Fetches only ongoing jobs assigned to a vendor
  Future<Object?> apiGetVendorOngoingJobs(String vendorId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathVendorOngoingJobs,
      queryParam: vendorId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final ongoingJobAssignedResponse = onGoingJobAssignedResponseFromJson(jsonEncode(response?.data));
      return ongoingJobAssignedResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }


  Future<Object?> apiVendorHistoryList(VendorIdRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathVendorHistoryList,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final vendorHistoryListResponse = vendorHistoryListResponseFromJson(jsonEncode(response?.data));
      return vendorHistoryListResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiVendorHistoryDetails(VendorHistoryDetailRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathVendorHistoryDetail,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final vendorHistoryDetailResponse = vendorHistoryDetailResponseFromJson(jsonEncode(response?.data));
      return vendorHistoryDetailResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }
}
