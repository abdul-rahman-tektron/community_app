import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/register/customer_register_request.dart';
import 'package:community_app/core/model/common/register/vendor_register_request.dart';
import 'package:community_app/core/model/vendor/add_vendor_service/add_vendor_service_request.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

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

    if (response?.statusCode == HttpStatus.ok) {
      final registerResponse = customerRegisterRequestFromJson(jsonEncode(response?.data));
      return registerResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  /// POST: /Vendor/AddVendorService
  /// Purpose: Adds services provided by a vendor (used during onboarding or updating services)
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
}
