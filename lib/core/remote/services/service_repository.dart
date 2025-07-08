import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/error/error_response.dart';
import 'package:community_app/core/model/login/login_request.dart';
import 'package:community_app/core/model/login/login_response.dart';
import 'package:community_app/core/model/register/customer_register_request.dart';
import 'package:community_app/core/model/register/vendor_register_request.dart';
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

