import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/vendor/dashboard/vendor_dashboard_response.dart';
import 'package:community_app/core/model/vendor/jobs/job_info_detail_response.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

class VendorDashboardRepository extends BaseRepository {
  VendorDashboardRepository._internal();
  static final instance = VendorDashboardRepository._internal();

  Future<Object?> apiVendorDashboard(String vendorId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathVendorDashboard,
      queryParam: vendorId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final vendorDashboardResponse = vendorDashboardResponseFromJson(jsonEncode(response?.data));
      return vendorDashboardResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }

  Future<Object?> apiJobInfoDetail(String jobId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.get,
      pathUrl: ApiUrls.pathJobInfoDetail,
      queryParam: jobId,
      headers: buildHeaders(token: token),
    );

    if (response?.statusCode == HttpStatus.ok) {
      final jobInfoDetailResponse = jobInfoDetailResponseFromJson(jsonEncode(response?.data));
      return jobInfoDetailResponse;
    } else {
      throw ErrorResponse.fromJson(response?.data ?? {});
    }
  }
}