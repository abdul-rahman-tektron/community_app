class ApiUrls {
  ApiUrls._();

  ///Base
  static const baseHttp = "https://";
  static const baseHost = "teksmartsolutions.com/CommunityServiceAPI";

  ///Test
  // static const baseHttp = "http://";
  // static const baseHost = "192.168.10.30/CommunityServiceAPI/api";

  static const baseUrl = "$baseHttp$baseHost";

  ///Common
  static const pathLogin = "/api/Auth/login"; // POST
  static const pathServiceDropdown = "/api/Service"; // GET
  static const pathCommunityDropdown = "/api/Community"; // GET
  static const pathChangePassword = "/commonapi/Common/change-password"; // POST
  static const pathForgotPassword = "/commonapi/Common/forgot-password"; // POST
  static const pathVerifyOTP = "/commonapi/Common/verify-otp"; // POST
  static const pathResetPassword = "/commonapi/Common/reset-password"; // POST
  static const pathRegisterToken = "/commonapi/Common/register-token"; // POST

  ///Customer
  static const pathCustomerRegister = "/api/Customer/CreateCustomer"; // POST
  static const pathUpdateUser = "/api/Customer/updatecustomer/"; // PUT
  static const pathTopVendor = "/api/Vendor/GetAllVendorsforService/"; // GET
  static const pathQuotationList = "/api/Job/GetCustomerJobsByJobId/"; // GET
  static const pathQuotationRequest = "/api/Job/CreateJobQuotationRequest"; // POST
  static const pathCreateJobBooking = "/api/Job/CreateJobBooking"; // POST
  static const pathCustomerOngoingJobs = "/api/Job/GetCustomerOngoingJobs/"; // GET
  static const pathQuotationRequestList = "/api/Job/GetJobsByCustomer/"; // GET
  static const pathCreateJob = "/api/Job/CreateJob"; // POST
  static const pathCustomerDashboard = "/api/Customer/GetDashboard/"; // GET
  static const pathCustomerDelete = "/api/Customer/deletecustomer/"; // GET
  static const pathUpdateCustomerCompletion = "/api/Job/update-customer-completion"; // PUT
  static const pathJobCompletionDetails = "/api/Job/GetJobCompletionDetails/"; // PUT
  static const pathJobStatusTracking = "/api/Job/JobStatusTracking"; // POST
  static const pathJobStatus = "/commonapi/Common/JobStatuses"; // POST
  static const pathUpdateJobStatus = "/api/Job/UpdateJobStatus"; // POST
  static const pathExploreService = "/api/Service/ExploreServices"; // GET
  static const pathServiceDetail = "/api/Job/ServiceDetail"; // GET
  static const pathCustomerHistoryList = "/api/Job/CustomerHistoryList"; // POST
  static const pathCustomerHistoryDetail = "/api/Job/CustomerHistoryDetail"; // POST
  static const pathSiteVisitCustomerResponse = "/api/SiteVisit/CustomerResponse"; // POST
  static const pathPaymentDetail = "/api/JobPayment/GetPaymentdetails"; // POST
  static const pathCreatePayment = "/api/JobPayment/CreatePayment"; // POST

  ///Vendor
  static const pathVendorRegister = "/api/Vendor/RegisterVendor"; // POST
  static const pathVendorJobs = "/api/Job/GetVendorJobs/"; // GET
  static const pathAddVendorService = "/api/Vendor/AddVendorService"; // POST
  static const pathUpdateVendorService = "/api/Vendor/updateVendorService"; // POST
  static const pathGetAllVendorServices = "/api/Vendor/GetAllVendorServices/"; // POST
  static const pathVendorQuotationRequestList = "/api/Job/GetAllQuotationsByVendor/"; // GET
  static const pathAssignEmployees = "/api/Job/AssignEmployees"; // POST
  static const pathVendorOngoingJobs = "/api/Job/GetVendorOngoingJobs/"; // GET
  static const pathVendorJobQuotationRequest = "/api/Job/CreateJobQuotationResponse"; // POST
  static const pathCreateSiteVisitRequest = "/api/SiteVisit/CreateRequest"; // POST
  static const pathSiteVisitAssignEmployee = "/api/SiteVisit/AssignEmployee"; // POST
  static const pathJobCompletion = "/api/Job/JobCompletion"; // POST
  static const pathVendorDashboard = "/api/Vendor/GetVendorDashboard/"; // GET
  static const pathJobInfoDetail = "/api/Job/JobInfoDetail/"; // GET
  static const pathQuotationResponseDetail = "/api/Job/GetquotationResponseDetails/"; // GET
  static const pathVendorHistoryList = "/api/Job/VendorHistoryList"; // POST
  static const pathVendorHistoryDetail = "/api/Job/VendorHistoryDetail"; // POST
}
