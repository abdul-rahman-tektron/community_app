import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:community_app/core/remote/network/api_url.dart';
import 'package:community_app/main.dart';
import 'package:community_app/utils/enums.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class NetworkRepository {
  NetworkRepository._internal() {
    _dio.interceptors.add(_buildInterceptor());
  }

  static final NetworkRepository _instance = NetworkRepository._internal();

  factory NetworkRepository() => _instance;

  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: ApiUrls.baseUrl,
    responseType: ResponseType.json,
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 60),
    sendTimeout: const Duration(seconds: 60),
  );

  final Dio _dio = Dio(_baseOptions);

  final Duration _timeout = const Duration(minutes: 2);

  InterceptorsWrapper _buildInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add headers or log request if needed here
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioError e, handler) async {

        if (e.message!.contains("XMLHttpRequest error")) {
          // MyApp.navigatorKey.currentState?.pushNamed(AppRoutes.networkError);
        }
        handler.next(e);
      },
    );
  }

  Future<Response?> call({
    required String pathUrl,
    Method method = Method.get,
    dynamic body,
    String? queryParam,
    Map<String, dynamic>? headers,
    bool urlEncoded = false,
    ResponseType? responseType,
  }) async {
    final url = _buildUrl(pathUrl, queryParam);

    final options = Options(
      headers: urlEncoded
          ? {'Content-Type': Headers.formUrlEncodedContentType, ...?headers}
          : headers,
      responseType: responseType,
    );

    // Check internet connectivity before making request
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // showNoInternetPopup(navigatorKey.currentContext!);
      _logger.w("No internet connection. Request to $url was not sent.");
      return null;
    }

    try {
      _logger.i("Request => ${method.name} $url");
      if (body != null) _logger.d("Request Body: $body");
      // log("Request Body: $body");

      late Response response;

      switch (method) {
        case Method.get:
          response = await _dio.get(url, options: options).timeout(_timeout);
          break;
        case Method.post     :
          response = await _dio.post(url, data: body, options: options).timeout(_timeout);
          break;
        case Method.put:
          response = await _dio.put(url, data: body, options: options).timeout(_timeout);
          break;
        case Method.delete:
          response = await _dio.delete(url, data: body, options: options).timeout(_timeout);
          break;
      }

      _logger.i("Response [${response.statusCode}] from $url");
      _logger.d("Response Data: ${jsonEncode(response.data)}");
      log("Response Data: ${jsonEncode(response.data)}");

      return response;
    } on DioError catch (e, stack) {
      await _handleError(e);
      _logger.e("DioError returning response directly: ${e.response}");
      return e.response;  // return the raw Dio error response
    } catch (e) {
      _logger.e("Unexpected error during request to $url: $e");
      return Response(
        requestOptions: RequestOptions(path: url),
        statusCode: HttpStatus.internalServerError,
        statusMessage: "An unexpected error occurred",
      );
    }
  }

  String _buildUrl(String pathUrl, String? queryParam) {
    return Uri.encodeFull('$pathUrl${queryParam ?? ''}');
  }

  Future<void> _handleError(DioError error) async {
    final status = error.response?.statusCode ?? 0;
    final url = error.requestOptions.path;

    _logger.e("DioError [$status] from $url");
    _logger.e("Error response: ${error.response?.data}");

    switch (status) {
      // case HttpStatus.unauthorized:
      //   if (![ApiUrls.logi].any(url.contains)) {
      //     try {
      //       await SecureStorageHelper.clearExceptRememberMe();
      //     } catch (e, stack) {
      //       await ErrorHandler.recordError(
      //         e,
      //         stack,
      //         context: {
      //           'widget': 'Unauthorized Interceptor',
      //           'action': 'clearExceptRememberMe',
      //           'message': e.toString(),
      //         },
      //       );
      //       print("SecureStorage deletion error (unauthorized): $e");
      //     }
      //
      //
      //     navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //       AppRoutes.login,
      //           (_) => false,
      //     );
      //   }
      //   break;

      case HttpStatus.forbidden:
        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.notFound,
              (_) => false,
        );
        break;

      default:
      // Other error handling as needed
        break;
    }
  }
}
