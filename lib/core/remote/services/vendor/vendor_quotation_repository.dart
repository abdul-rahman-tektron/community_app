import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/customer/top_vendors/top_vendors_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/create_site_viist_request.dart';
import 'package:community_app/core/model/vendor/quotation_request/create_site_visit_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_response_detail_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/site_visit_assign_employee_request.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/create_job_quotation_request.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

class VendorQuotationRepository extends BaseRepository {
  VendorQuotationRepository._internal();
  static final instance = VendorQuotationRepository._internal();

  /// POST: /Job/CreateJobQuotationResponse
  /// Purpose: Allows a vendor to submit a quotation for a customer’s job request
  Future<Object?> apiVendorCreateJobQuotationRequest(VendorCreateJobQuotationRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathVendorJobQuotationRequest,
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

  /// GET: /Job/GetAllQuotationsByVendor/{vendorId}
  /// Purpose: Fetches all job quotation requests sent to a vendor
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

  Future<Object?> apiQuotationDetail(String quotationResponseId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathQuotationResponseDetail,
      queryParam: quotationResponseId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final quotationResponseDetailResponse = quotationResponseDetailResponseFromJson(jsonEncode(response?.data));
      return quotationResponseDetailResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  /// POST: /Job/CreateJobQuotationResponse
  /// Purpose: Allows a vendor to submit a quotation for a customer’s job request
  Future<Object?> apiCreateSiteVisit(CreateSiteVisitRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCreateSiteVisitRequest,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final createSiteVisitResponse = createSiteVisitResponseFromJson(jsonEncode(response?.data));
      return createSiteVisitResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiSiteVisitAssignEmployee(SiteVisitAssignEmployeeRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathSiteVisitAssignEmployee,
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

}
