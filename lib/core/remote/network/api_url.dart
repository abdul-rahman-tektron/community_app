class ApiUrls {
  ApiUrls._();

  static final baseHost = "teksmartsolutions.com/CommunityServiceAPI/api";
  // static final baseHost = "teksmartsolutions.com/MOFAAPI/api";
  static final baseHttp = "https://";
  static final baseUrl = "$baseHttp$baseHost";

  //Auth
  static final pathLogin = "/Auth/login";
  static final pathCustomerRegister = "/Customer/create";
  static final pathVendorRegister = "/Vendor/register";

  //Services
  static final pathServiceDropdown = "/Service";
  static final pathCommunityDropdown = "/Community";
  static final pathCreateJob = "/Job/create";
}