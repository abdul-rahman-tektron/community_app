import 'package:community_app/utils/enums.dart';

mixin CommonUtils {

  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static String getLocalizedString({
    required String currentLang,
    required String? Function() getArabic,
    required String? Function() getEnglish,
    String fallback = 'Unknown',
  }) {
    if (currentLang == LanguageCode.ar.name) {
      return getArabic() ?? fallback;
    } else {
      return getEnglish() ?? fallback;
    }
  }

  static JobStatusCategory jobStatusFromString(String? status) {
    switch (status?.toLowerCase()) {
      case 'tracking':
        return JobStatusCategory.tracking;
      case 'inprogress':
      case 'in_progress':
      case 'in progress':
        return JobStatusCategory.inProgress;
      case 'completed':
        return JobStatusCategory.completed;
      default:
        return JobStatusCategory.unknown;
    }
  }
}

class AppStatusData {
  final int id;
  final double percentage;
  final String name;

  const AppStatusData(this.id, this.percentage, this.name);
}

class AppStatus {
  static const jobInitiated = AppStatusData(1, 0, "Job Initiated");
  static const quotationRequested = AppStatusData(2, 5, "Quotation Requested");
  static const vendorQuotationRejected = AppStatusData(3, 8, "Vendor Quotation Rejected");
  static const siteVisitRequestedByCustomer = AppStatusData(4, 10, "Site Visit Requested by Customer");
  static const siteVisitRequestedByVendor = AppStatusData(5, 12, "Site Visit Requested by Vendor");
  static const siteVisitRejected = AppStatusData(6, 15, "Site Visit Rejected");
  static const quotationSubmitted = AppStatusData(7, 20, "Quotation Submitted");
  static const quotationAccepted = AppStatusData(8, 30, "Quotation Accepted");
  static const employeeAssigned = AppStatusData(9, 35, "Employee Assigned");
  static const arrivedAtLocation = AppStatusData(10, 55, "Arrived at Location");
  static const workStartedInProgress = AppStatusData(11, 70, "Work Started / Work inProgress");
  static const workCompletedAwaitingConfirmation = AppStatusData(12, 85, "Work Completed - Awaiting Confirmation");
  static const jobVerifiedPaymentPending = AppStatusData(13, 90, "Job Verified & Payment Pending");
  static const paymentCompleted = AppStatusData(14, 95, "Payment Completed");
  static const clientFeedback = AppStatusData(15, 98, "Client Feedback");
  static const jobClosedDone = AppStatusData(16, 100, "Job Closed / Done");

  /// This makes it easy to iterate or search
  static const List<AppStatusData> values = [
    jobInitiated,
    quotationRequested,
    vendorQuotationRejected,
    siteVisitRequestedByCustomer,
    siteVisitRequestedByVendor,
    siteVisitRejected,
    quotationSubmitted,
    quotationAccepted,
    employeeAssigned,
    arrivedAtLocation,
    workStartedInProgress,
    workCompletedAwaitingConfirmation,
    jobVerifiedPaymentPending,
    paymentCompleted,
    clientFeedback,
    jobClosedDone,
  ];

  /// Get status by ID
  static AppStatusData? fromId(int id) {
    for (final status in values) {
      if (status.id == id) return status;
    }
    return null;
  }

  /// Get status by Name
  static AppStatusData? fromName(String name) {
    for (final status in values) {
      if (status.name == name) return status;
    }
    return null;
  }
}