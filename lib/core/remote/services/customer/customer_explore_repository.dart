import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/customer/explore/explore_service_response.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

class CustomerExploreRepository extends BaseRepository {
  CustomerExploreRepository._internal();
  static final instance = CustomerExploreRepository._internal();

  /// GET: /Job/GetJobsByCustomer/{customerId}
  /// Purpose: Retrieves the list of job requests (quotation requests) created by a customer
  Future<Object?> apiExploreService({
    String? search,
    String? sortBy,
    int? minPrice,
    int? maxPrice,
    int? serviceId,
  }) async {
    final token = await SecureStorageService.getToken();

    // Build query string dynamically
    final queryParams = <String>[];

    if (search != null && search.isNotEmpty) {
      queryParams.add("search=${Uri.encodeComponent(search)}");
    }
    if (sortBy != null && sortBy.isNotEmpty) {
      queryParams.add("sortBy=${Uri.encodeComponent(sortBy)}");
    }
    if (minPrice != null) {
      queryParams.add("minPrice=$minPrice");
    }
    if (maxPrice != null) {
      queryParams.add("maxPrice=$maxPrice");
    }
    if (serviceId != null) {
      queryParams.add("serviceId=$serviceId");
    }

    final queryString = queryParams.isNotEmpty ? "?${queryParams.join("&")}" : "";

    print("queryString: $queryString");

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: "${ApiUrls.pathExploreService}$queryString",
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final exploreServiceResponse =
      exploreServiceResponseFromJson(jsonEncode(response?.data));
      return exploreServiceResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  /// GET: /Job/GetJobsByCustomer/{customerId}
  /// Purpose: Retrieves the list of job requests (quotation requests) created by a customer
  Future<Object?> apiServiceDetails(String vendorId, String? serviceId) async {
    final token = await SecureStorageService.getToken();

    String? queryString;

    if (serviceId != null) {
      queryString = "?serviceId=$serviceId";
    }


    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: "${ApiUrls.pathServiceDetail}/$vendorId$queryString",
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      // final customerRequestListResponse = customerRequestListResponseFromJson(jsonEncode(response?.data));
      // return customerRequestListResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }
}