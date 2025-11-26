import 'dart:convert';
import 'dart:io';

import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/common/error/error_response.dart';
import 'package:Xception/core/model/customer/dashboard/customer_dashboard_response.dart';
import 'package:Xception/core/model/customer/job/create_job_booking_request.dart';
import 'package:Xception/core/model/customer/job/create_job_booking_response.dart';
import 'package:Xception/core/model/customer/quotation/quotation_request_list_response.dart';
import 'package:Xception/core/model/vendor/quotation_request/quotation_request_list_response.dart';
import 'package:Xception/core/model/vendor/quotation_request/quotation_request_request.dart';
import 'package:Xception/core/remote/network/api_url.dart';
import 'package:Xception/core/remote/network/base_repository.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/storage/secure_storage.dart';

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

// CustomerDashboardRepository.dart (or wherever apiCreateJobBookingRequest lives)
  Future<Object?> apiCreateJobBookingRequest(CreateJobBookingRequest req) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCreateJobBooking, // your URL
      body: jsonEncode(req.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final data = response?.data;

      // Booking may return emailPreview just like site-visit
      if (data["emailPreview"] != null) {
        return jobBookingResponseFromJson(jsonEncode(data));       // ✅ send email
      } else {
        return commonResponseFromJson(jsonEncode(data));           // ✅ generic success
      }
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
