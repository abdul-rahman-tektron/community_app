import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/dropdown/community_dropdown_response.dart';
import 'package:community_app/core/model/dropdown/service_dropdown_response.dart';
import 'package:community_app/core/model/error/error_response.dart';
import 'package:community_app/core/model/job/new_job_request.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/res/api_constants.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';
import 'package:dio/dio.dart';

class ServiceRepository extends BaseRepository {
  ServiceRepository._internal();

  static final ServiceRepository _singleInstance = ServiceRepository._internal();

  factory ServiceRepository() => _singleInstance;

  //api: Service Dropdown Api
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

  //api: Community Dropdown Api
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

  //api: Community Dropdown Api
  Future<Object?> apiNewJob(CreateJobRequest requestParams) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.post,
      pathUrl: ApiUrls.pathCreateJob,
      body: jsonEncode(requestParams.toJson()),
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final communityDropdownResponse = communityDropdownResponseFromJson(jsonEncode(response?.data));

      return communityDropdownResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  // New method to get Google Directions API response
  Future<Map<String, dynamic>> getRouteWithTraffic({
    required String origin,
    required String destination,
  }) async {
    final String apiKey = ApiConstants.apiKey;
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&departure_time=now&key=$apiKey';

    try {
      final dio = Dio();
      final response = await dio.get(url);

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ErrorResponse.fromJson(response.data ?? {});
      }
    } catch (e) {
      rethrow; // Let caller handle the error
    }
  }
}

