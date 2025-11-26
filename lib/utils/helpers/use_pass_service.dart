import 'package:dio/dio.dart';
import 'package:flutter_uae_pass/flutter_uae_pass.dart';
import 'package:flutter/material.dart';

class UAEPassService {
  final UaePass _uaePass = UaePass();
  final Dio _dio = Dio();

  // Initialize plugin environment, call once
  Future<void> initialize({bool isProduction = false}) async {
    if (isProduction) {
      await _uaePass.setUpEnvironment(
        clientId: "sandbox_stage",
        clientSecret: "sandbox_stage",
        urlScheme: "com.example.Xception",
        redirectUri: "com.example.Xception://success",
        isProduction: true,
        language: "en",
      );
    } else {
      await _uaePass.setUpSandbox();
    }
  }

  // Sign in and get access token
  Future<String> signIn(BuildContext context) async {
    try {
      final authCode = await _uaePass.signIn();
      if (authCode == null) {
        throw Exception("Authorization code not received");
      }
      final accessToken = await _uaePass.getAccessToken(authCode);
      if (accessToken == null) {
        throw Exception("Access token not received");
      }
      return accessToken;
    } catch (e) {
      // Show error snackbar if you want or rethrow
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("UAE Pass login failed: $e"), backgroundColor: Colors.red),
      );
      throw e;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String accessToken) async {
    try {
      final response = await _dio.get(
        'https://stg-id.uaepass.ae/idshub/userinfo', // Your userInfoUrl from constants
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
        }),
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      // handle or log error if needed
    }
    return null;
  }
}
