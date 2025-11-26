class ApiConstants {
  ApiConstants._();

  static const timeout = Duration(seconds: 30);
  static const defaultPageSize = 20;

  static const apiKey = "AIzaSyAqO39DAseHSaLtcKC1T6u6-uPz8_Lp7YA";

  static const String clientId = "sandbox_stage";
  static const String clientSecret = "sandbox_stage";
  static const String redirectUri = "com.tektronix.xception://uaepass-callback";
  static const String authUrl = "https://stg-id.uaepass.ae/idshub/authorize";
  static const String tokenUrl = "https://stg-id.uaepass.ae/idshub/token";
  static const String userInfoUrl = "https://stg-id.uaepass.ae/idshub/userinfo";
  static const String scope = "urn:uae:digitalid:profile";
  static const String acrValues = "urn:safelayer:tws:policies:authentication:level:low";
}