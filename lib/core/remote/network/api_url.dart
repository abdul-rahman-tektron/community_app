class ApiUrls {
  ApiUrls._();

  ///Base
  static const baseHttp = "https://";
  static const baseHost = "teksmartsolutions.com/CommunityServiceAPI/api";

  ///Test
  // static const baseHttp = "http://";
  // static const baseHost = "192.168.10.30/CommunityServiceAPI/api";

  static const baseUrl = "$baseHttp$baseHost";

  ///Common
  static const pathLogin = "/Auth/login"; // POST
  static const pathServiceDropdown = "/Service"; // GET
  static const pathCommunityDropdown = "/Community"; // GET

  ///Customer
  static const pathCustomerRegister = "/Customer/CreateCustomer"; // POST
  static const pathUpdateUser = "/Customer/updatecustomer/"; // PUT
  static const pathTopVendor = "/Vendor/GetAllVendorsforService/"; // GET
  static const pathQuotationList = "/Job/GetCustomerJobsByJobId/"; // GET
  static const pathQuotationRequest = "/Job/CreateJobQuotationRequest"; // POST
  static const pathCreateJobBooking = "/Job/CreateJobBooking"; // POST
  static const pathCustomerOngoingJobs = "/Job/GetCustomerOngoingJobs/"; // GET
  static const pathQuotationRequestList = "/Job/GetJobsByCustomer/"; // GET
  static const pathCreateJob = "/Job/CreateJob"; // POST
  static const pathCustomerDashboard = "/Customer/GetDashboard/"; // GET
  static const pathCustomerDelete = "/Customer/deletecustomer/"; // GET

  ///Vendor
  static const pathVendorRegister = "/Vendor/RegisterVendor"; // POST
  static const pathVendorJobs = "/Job/GetVendorJobs/"; // GET
  static const pathAddVendorService = "/Vendor/AddVendorService"; // POST
  static const pathVendorQuotationRequestList = "/Job/GetAllQuotationsByVendor/"; // GET
  static const pathAssignEmployees = "/Job/AssignEmployees"; // POST
  static const pathVendorOngoingJobs = "/Job/GetVendorOngoingJobs/"; // GET
  static const pathVendorJobQuotationRequest = "/Job/CreateJobQuotationResponse"; // POST
  static const pathJobCompletion = "/Job/JobCompletion"; // POST
  static const pathVendorDashboard = "/Vendor/GetVendorDashboard/"; // GET
}
