import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/error/error_response.dart';
import 'package:community_app/core/model/login/login_request.dart';
import 'package:community_app/core/model/login/login_response.dart';
import 'package:community_app/core/model/register/customer_register_request.dart';
import 'package:community_app/core/model/register/vendor_register_request.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

class AuthRepository extends BaseRepository {
  AuthRepository._internal();

  static final AuthRepository _singleInstance = AuthRepository._internal();

  factory AuthRepository() => _singleInstance;

  //api: Logins
  Future<Object?> apiUserLogin(LoginRequest requestParams) async {
    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathLogin,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final loginTokenResponse = loginResponseFromJson(jsonEncode(response?.data));
      final token = loginTokenResponse.token ?? "";
      await SecureStorageService.setToken(token);
      await HiveStorageService.setUserData(jsonEncode(loginTokenResponse));
      return loginTokenResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  //api: Customer Register
  Future<Object?> apiCustomerRegister(CustomerRegisterRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCustomerRegister,
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

  //api: Vendor Register
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
}

