import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/register/customer_register_request.dart';
import 'package:community_app/core/model/common/user/update_user_request.dart';
import 'package:community_app/core/model/common/user/update_user_response.dart';
import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/core/remote/network/base_repository.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/storage/secure_storage.dart';

class CustomerAuthRepository extends BaseRepository {
  CustomerAuthRepository._internal();
  static final instance = CustomerAuthRepository._internal();

  /// POST: /Customer/CreateCustomer
  /// Purpose: Registers a new customer with the provided details
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

  /// PUT: /Customer/updatecustomer/{userId}
  /// Purpose: Updates an existing customer’s profile using the provided userId and updated data
  Future<Object?> apiUpdateCustomerProfile(String userId, UpdateUserRequest requestParams) async {
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

  Future<Object?> apiDeleteCustomer(String customerId) async {
    final token = await SecureStorageService.getToken();

    final response = await networkRepository.call(
      method: Method.delete,
      pathUrl: ApiUrls.pathCustomerDelete,
      queryParam: customerId,
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
