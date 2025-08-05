import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/dropdown/community_dropdown_response.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/login/login_request.dart';
import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/crashlytics_service.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

import '../../model/common/dropdown/service_dropdown_response.dart' show serviceDropdownResponseFromJson;

class CommonRepository extends BaseRepository {
  CommonRepository._internal();
  static final instance = CommonRepository._internal();

  /// POST: /Auth/login
  /// Purpose: Authenticates a user and retrieves an access token
  /// Stores the token in secure storage and saves user data in Hive for quick access
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

      CrashlyticsService.setUser({
        "id": loginTokenResponse.customerId,
        "name": loginTokenResponse.name,
        "email": loginTokenResponse.email,
        "role": loginTokenResponse.type,
      });
      return loginTokenResponse;
    }

    if (statusCode == HttpStatus.unauthorized) {
      return ErrorResponse(title: "Invalid credentials");
    }

    return ErrorResponse.fromJson(data ?? {});
  }

  /// GET: /Service
  /// Purpose: Fetches the list of available services (used in dropdowns)
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
}
