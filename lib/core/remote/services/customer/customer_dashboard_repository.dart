import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/customer/dashboard/customer_dashboard_response.dart';
import 'package:community_app/core/model/customer/job/create_job_booking_request.dart';
import 'package:community_app/core/model/customer/quotation/quotation_request_list_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_request.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

class CustomerDashboardRepository extends BaseRepository {
  CustomerDashboardRepository._internal();
  static final instance = CustomerDashboardRepository._internal();

  /// GET: /Job/GetCustomerJobsByJobId/{jobId}
  /// Purpose: Fetches the list of quotations submitted by vendors for a specific job
  Future<Object?> apiQuotationList(String jobId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathQuotationList,
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

  /// GET: /Job/GetJobsByCustomer/{customerId}
  /// Purpose: Retrieves the list of job requests (quotation requests) created by a customer
  Future<Object?> apiQuotationRequestList(String customerId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathQuotationRequestList,
      queryParam: customerId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final customerRequestListResponse = customerRequestListResponseFromJson(jsonEncode(response?.data));
      return customerRequestListResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  /// POST: /Job/CreateJobBooking
  /// Purpose: Creates a job booking by selecting one vendor from the top vendor list
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

  /// POST: /Job/CreateJobQuotationRequest
  /// Purpose: Sends a quotation request to selected vendors for a particular job
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


  Future<Object?> apiCustomerDashboard(String customerId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathCustomerDashboard,
      queryParam: customerId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final customerDashboardResponse = customerDashboardResponseFromJson(jsonEncode(response?.data));
      return customerDashboardResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }
}
