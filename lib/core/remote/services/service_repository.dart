import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/dropdown/community_dropdown_response.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/customer/job/create_job_booking_request.dart';
import 'package:community_app/core/model/customer/job/job_completion_request.dart';
import 'package:community_app/core/model/customer/job/new_job_request.dart';
import 'package:community_app/core/model/customer/job/ongoing_jobs_response.dart';
import 'package:community_app/core/model/customer/top_vendors/top_vendors_response.dart';
import 'package:community_app/core/model/vendor/add_vendor_service/add_vendor_service_request.dart';
import 'package:community_app/core/model/vendor/assign_employee/assign_employee_request.dart';
import 'package:community_app/core/model/vendor/jobs/ongoing_jobs_assigned_response.dart';
import 'package:community_app/core/model/vendor/jobs/ongoing_jobs_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_request.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/create_job_quotation_request.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/res/api_constants.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:dio/dio.dart';

import '../../model/common/dropdown/service_dropdown_response.dart';

class ServiceRepository extends BaseRepository {
  ServiceRepository._internal();

  static final ServiceRepository _singleInstance = ServiceRepository._internal();

  factory ServiceRepository() => _singleInstance;

  //api: Service Dropdown Api
  Future<Object?> apiServiceDropdown() async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathServiceDropdown,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final serviceDropdownResponse = serviceDropdownResponseFromJson(jsonEncode(response?.data));

      return serviceDropdownResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  //api: Community Dropdown Api
  Future<Object?> apiCommunityDropdown() async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathCommunityDropdown,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final communityDropdownResponse = communityDropdownResponseFromJson(jsonEncode(response?.data));

      return communityDropdownResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  //api: Community Dropdown Api
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

  // New method to get Google Directions API response
  Future<Map<String, dynamic>> getRouteWithTraffic({
    required String origin,
    required String destination,
  }) async {
    final String apiKey = ApiConstants.apiKey;
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&departure_time=now&key=$apiKey';

    try {
      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ErrorResponse.fromJson(response.data ?? {});
      }
    } catch (e) {
      rethrow; // Let caller handle the error
    }
  }

  //api: Community Dropdown Api
  Future<Object?> apiAddVendorService(AddVendorServiceRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathAddVendorService,
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

  Future<Object?> apiQuotationRequest(QuotationRequestRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathQuotationRequest,
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

  Future<Object?> apiVendorCreateJobQuotationRequest(VendorCreateJobQuotationRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathVendorJobQuotationRequest,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final topVendorResponse = topVendorResponseFromJson(jsonEncode(response?.data));
      return topVendorResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiQuotationRequestList(String jobId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathQuotationRequestList,
      queryParam: jobId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final quotationRequestListResponse = quotationRequestListResponseFromJson(jsonEncode(response?.data));
      return quotationRequestListResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiVendorQuotationRequestList(String vendorId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathVendorQuotationRequestList,
      queryParam: vendorId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final vendorQuotationRequestListResponse = vendorQuotationRequestListResponseFromJson(jsonEncode(response?.data));
      return vendorQuotationRequestListResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiCreateJobBookingRequest(CreateJobBookingRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCreateJobBooking,
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
}

