import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/customer/top_vendors/top_vendors_response.dart';
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
      final topVendorResponse = topVendorResponseFromJson(jsonEncode(response?.data));
      return topVendorResponse;
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
}
