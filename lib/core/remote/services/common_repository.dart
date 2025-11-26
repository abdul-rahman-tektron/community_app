import 'dart:convert';
import 'dart:io';

import 'package:Xception/core/model/common/dropdown/community_dropdown_response.dart';
import 'package:Xception/core/model/common/error/common_basic_response.dart';
import 'package:Xception/core/model/common/error/common_response.dart';
import 'package:Xception/core/model/common/error/error_response.dart';
import 'package:Xception/core/model/common/login/login_request.dart';
import 'package:Xception/core/model/common/login/login_response.dart';
import 'package:Xception/core/model/common/login/register_token_request.dart';
import 'package:Xception/core/model/common/password/change_password_request.dart';
import 'package:Xception/core/model/common/password/reset_password_request.dart';
import 'package:Xception/core/model/common/password/send_otp_request.dart';
import 'package:Xception/core/model/common/password/verify_otp_request.dart';
import 'package:Xception/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:Xception/core/remote/network/api_url.dart';
import 'package:Xception/core/remote/network/base_repository.dart';
import 'package:Xception/utils/crashlytics_service.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/storage/hive_storage.dart';
import 'package:Xception/utils/storage/secure_storage.dart';

import '../../model/common/dropdown/service_dropdown_response.dart' show serviceDropdownResponseFromJson;

class CommonRepository extends BaseRepository {
  CommonRepository._internal();
  static final instance = CommonRepository._internal();

  /// POST: /Auth/login
  /// Purpose: Authenticates a user and retrieves an access token
  /// Stores the token in secure storage and saves user data in Hive for quick access
  Future<Object?> apiUserLogin(LoginRequest requestParams, {bool isRegister = false}) async {
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
      if (!isRegister) {
        await SecureStorageService.setToken(loginTokenResponse.token ?? "");
        await HiveStorageService.setUserData(jsonEncode(loginTokenResponse));

        CrashlyticsService.setUser({
          "id": loginTokenResponse.customerId,
          "name": loginTokenResponse.name,
          "email": loginTokenResponse.email,
          "role": loginTokenResponse.type,
        });
      }
      return loginTokenResponse;
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid credentials");
    }

    return ErrorResponse.fromJson(data ?? {});
  }

  /// GET: /Service
  /// Purpose: Fetches the list of available jobs (used in dropdowns)
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

  /// GET: /Community
  /// Purpose: Fetches the list of communities (used in dropdowns)
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

  Future<Object?> apiChangePassword(ChangePasswordRequest requestParams) async {
    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathChangePassword,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(),
    );

    final statusCode = response?.statusCode;
    final data = response?.data;
    final commonResponse = commonResponseFromJson(jsonEncode(data));

    if (statusCode == HttpStatus.ok) {

      return commonResponse;
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid credentials");
    }

    return commonResponse;
  }

  Future<Object?> apiForgetPassword(SendOtpRequest requestParams) async {
    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathForgotPassword,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(),
    );

    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == HttpStatus.ok) {
      final commonBasicResponse = data;

      return commonBasicResponse["message"];
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid credentials");
    }

    if (statusCode == HttpStatus.internalServerError) {
      return ErrorResponse(title: "Invalid credentials");
    }

    return ErrorResponse(title: "Something went wrong");
  }

  Future<Object?> apiVerifyOTP(VerifyOtpRequest requestParams) async {
    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathVerifyOTP,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(),
    );

    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == HttpStatus.ok) {
      final commonBasicResponse = data;

      return commonBasicResponse["isValid"];
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid OTP");
    }

    if (statusCode == HttpStatus.internalServerError) {
      return ErrorResponse(title: "Invalid OTP");
    }

    return ErrorResponse(title: "Something went wrong");
  }

  Future<Object?> apiResetPassword(ResetPasswordRequest requestParams) async {
    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathResetPassword,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(),
    );

    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == HttpStatus.ok) {
      final commonBasicResponse = data;

      return commonBasicResponse["message"];
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid Password");
    }

    if (statusCode == HttpStatus.internalServerError) {
      return ErrorResponse(title: "Invalid Password Format");
    }

    return ErrorResponse(title: "Something went wrong");
  }

  Future<Object?> apiUpdateJobStatus(UpdateJobStatusRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathUpdateJobStatus,
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

  Future<Object?> apiRegisterToken(RegisterTokenRequest requestParams) async {
    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathRegisterToken,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(),
    );

    final statusCode = response?.statusCode;
    final data = response?.data;

    if (statusCode == HttpStatus.ok) {
      final commonBasicResponse = commonBasicResponseFromJson(jsonEncode(data));

      return commonBasicResponse;
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid credentials");
    }

    return ErrorResponse.fromJson(data ?? {});
  }
}
