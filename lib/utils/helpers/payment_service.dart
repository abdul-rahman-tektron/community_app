import 'package:dio/dio.dart';

class PaymentService {
  static final Dio _dio = Dio();

  static Future<String?> createPaymentIntent(int amount) async {
    try {
      final response = await _dio.post(
        "https://your-backend-url.com/create-payment-intent",
        data: {
          "amount": amount,
          "currency": "usd",
        },
        options: Options(
          headers: {"Content-Type": "application/json"},
        ),
      );

      // response.data is already decoded JSON
      return response.data["clientSecret"];
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.data ?? e.message}");
      return null;
    } catch (e) {
      print("General Error: $e");
      return null;
    }
  }
}