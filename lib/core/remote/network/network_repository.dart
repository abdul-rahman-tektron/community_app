import 'dart:convert';
import 'dart:io';

import 'package:Xception/core/remote/network/api_url.dart';
import 'package:Xception/main.dart';
import 'package:Xception/utils/enums.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';


/// Standardized API error model
class ApiError {
  final int statusCode;
  final String message;
  final dynamic raw;

  ApiError({required this.statusCode, required this.message, this.raw});
}

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
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
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

  InterceptorsWrapper _buildInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i("➡️ Request => ${options.method} ${options.uri}");
        if (options.data != null) {
          _logger.d("Request Body: ${options.data}");
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i("✅ Response [${response.statusCode}] from ${response.realUri}");
        _logger.d("Response Data: ${jsonEncode(response.data)}");
        handler.next(response);
      },
      onError: (DioException e, handler) async {
        _logger.e("❌ DioError: ${e.message}");
        handler.next(e);
      },
    );
  }

  /// Generic API call without parser
  Future<Response?> call({
    required String pathUrl,
    Method method = Method.get,
    dynamic body,
    String? queryParam,
    Map<String, dynamic>? headers,
    bool urlEncoded = false,
    ResponseType? responseType,
    CancelToken? cancelToken,
    int retryCount = 0,
  }) async {
    final url = _buildUrl(pathUrl, queryParam);

    final options = Options(
      headers: urlEncoded
          ? {'Content-Type': Headers.formUrlEncodedContentType, ...?headers}
          : headers,
      responseType: responseType,
    );

    int attempts = 0;
    while (true) {
      try {
        late Response response;

        switch (method) {
          case Method.get:
            response = await _dio.get(
              url,
              options: options,
              cancelToken: cancelToken,
            );
            break;
          case Method.post:
            response = await _dio.post(
              url,
              data: body,
              options: options,
              cancelToken: cancelToken,
            );
            break;
          case Method.put:
            response = await _dio.put(
              url,
              data: body,
              options: options,
              cancelToken: cancelToken,
            );
            break;
          case Method.delete:
            response = await _dio.delete(
              url,
              data: body,
              options: options,
              cancelToken: cancelToken,
            );
            break;
        }

        return response;
      } on DioException catch (e) {
        if (attempts < retryCount &&
            (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.error is SocketException)) {
          attempts++;
          _logger.w("Retrying... attempt $attempts for $url");
          continue; // retry
        }
        await _handleError(e);
        return e.response;
      } catch (e) {
        _logger.e("Unexpected error during request to $url: $e");
        return Response(
          requestOptions: RequestOptions(path: url),
          statusCode: HttpStatus.internalServerError,
          statusMessage: "An unexpected error occurred",
        );
      }
    }
  }

  String _buildUrl(String pathUrl, String? queryParam) {
    return Uri.encodeFull('$pathUrl${queryParam ?? ''}');
  }

  Future<ApiError> _handleError(DioException error) async {
    final status = error.response?.statusCode ?? 0;
    final url = error.requestOptions.path;

    _logger.e("DioError [$status] from $url");
    _logger.e("Error response: ${error.response?.data}");

    switch (status) {
      case HttpStatus.unauthorized:
        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.login,
              (_) => false,
        );
        break;

      case HttpStatus.forbidden:
        MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.notFound,
              (_) => false,
        );
        break;

      default:
        break;
    }

    return ApiError(
      statusCode: status,
      message: error.message ?? "Unknown error",
      raw: error.response?.data,
    );
  }
}