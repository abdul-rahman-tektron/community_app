class ApiUrls {
  ApiUrls._();

  static final baseHost = "teksmartsolutions.com/CommunityServiceAPI/api";
  // static final baseHost = "teksmartsolutions.com/MOFAAPI/api";
  static final baseHttp = "https://";
  static final baseUrl = "$baseHttp$baseHost";

  //Auth
  static final pathLogin = "/Auth/login";
  static final pathCustomerRegister = "/Customer/CreateCustomer";
  static final pathVendorRegister = "/Vendor/RegisterVendor";
  static final pathUpdateUser = "/Customer/updatecustomer/";
  static final pathTopVendor = "/Vendor/GetAllVendorsforService/";
  static final pathQuotationRequestList = "/Job/GetCustomerJobsByJobId/";
  static final pathVendorQuotationRequestList = "/Job/GetAllQuotationsByVendor/";
  static final pathQuotationRequest = "/Job/CreateJobQuotationRequest";
  static final pathVendorJobQuotationRequest = "/Job/CreateJobQuotationResponse";
  static final pathCreateJobBooking = "/Job/CreateJobBooking";
  static final pathVendorJobs = "/Job/GetVendorJobs/";
  static final pathVendorOngoingJobs = "/Job/GetVendorOngoingJobs/";
  static final pathCustomerOngoingJobs = "/Job/GetCustomerOngoingJobs/";
  static final pathAssignEmployees = "/Job/AssignEmployees";
  static final pathJobCompletion = "/api/Job/JobCompletion";

  //Services
  static final pathServiceDropdown = "/Service";
  static final pathCommunityDropdown = "/Community";
  static final pathCreateJob = "/Job/CreateJob";
  static final pathAddVendorService = "/Vendor/AddVendorService";
}