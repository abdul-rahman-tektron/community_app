import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/login/login_request.dart';
import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/core/model/common/register/customer_register_request.dart';
import 'package:community_app/core/model/common/register/vendor_register_request.dart';
import 'package:community_app/core/model/common/user/update_user_request.dart';
import 'package:community_app/core/model/common/user/update_user_response.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
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

    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == HttpStatus.ok) {
      final loginTokenResponse = loginResponseFromJson(jsonEncode(data));
      await SecureStorageService.setToken(loginTokenResponse.token ?? "");
      await HiveStorageService.setUserData(jsonEncode(loginTokenResponse));
      return loginTokenResponse;
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid credentials");
    }

    return ErrorResponse.fromJson(data ?? {});
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

  //api: Vendor Register
  Future<Object?> apiUpdateUserProfile(String userId, UpdateUserRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.put,
      pathUrl: ApiUrls.pathUpdateUser,
      queryParam: userId,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final updateUserResponse = updateUserResponseFromJson(jsonEncode(response?.data));
      return updateUserResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }
}

