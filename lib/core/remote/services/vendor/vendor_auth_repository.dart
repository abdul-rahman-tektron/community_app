import 'dart:convert';
import 'dart:io';

import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/common/error/error_response.dart';
import 'package:Xception/core/model/common/register/customer_register_request.dart';
import 'package:Xception/core/model/common/register/vendor_register_request.dart';
import 'package:Xception/core/model/vendor/add_vendor_service/add_vendor_service_request.dart';
import 'package:Xception/core/model/vendor/service/get_all_vendor_service_response.dart';
import 'package:Xception/core/remote/network/api_url.dart';
import 'package:Xception/core/remote/network/base_repository.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/storage/secure_storage.dart';

class VendorAuthRepository extends BaseRepository {
  VendorAuthRepository._internal();
  static final instance = VendorAuthRepository._internal();

  /// POST: /Vendor/RegisterVendor
  /// Purpose: Registers a new vendor with the provided details
  Future<Object?> apiVendorRegister(VendorRegisterRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathVendorRegister,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    final data = response?.data ?? {};

    if (response?.statusCode == HttpStatus.ok) {
      final registerResponse = customerRegisterRequestFromJson(jsonEncode(response?.data));
      return registerResponse;
    } else {

      // Normalize any API error to ErrorResponse
      if (data is Map<String, dynamic>) {
        // Check if it's already structured validation error
        if (data.containsKey("errors")) {
          return ErrorResponse.fromJson(data);
        } else {
          // Convert plain error JSON to ErrorResponse
          return commonResponseFromJson(jsonEncode(data));
        }
      } else {
        // fallback
        return ErrorResponse(
          title: "An unexpected error occurred",
          status: response?.statusCode ?? 400,
        );
      }
    }
  }

  /// POST: /Vendor/AddVendorService
  /// Purpose: Adds jobs provided by a vendor (used during onboarding or updating jobs)
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

  Future<Object?> apiUpdateVendorService(AddVendorServiceRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathUpdateVendorService,
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


  Future<Object?> apiGetAllVendorServices(String vendorId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathGetAllVendorServices,
      queryParam: vendorId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final getAllVendorServiceResponse = getAllVendorServiceResponseFromJson(jsonEncode(response?.data));
      return getAllVendorServiceResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }
}
