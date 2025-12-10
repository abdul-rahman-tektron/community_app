import 'package:dio/dio.dart';

class PaymentService {
  static final Dio _dio = Dio();

  static Future<String?> createPaymentIntent({
    required int amountInMinorUnits,
    required String currency,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/create-intent',
        data: {
          'amount': amountInMinorUnits,
          'currency': currency,
          'description': description,
        },
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['clientSecret'] != null) {
        return response.data['clientSecret'] as String;
      }

      return null;
    } catch (e) {
      // You can log error here
      return null;
    }
  }
}