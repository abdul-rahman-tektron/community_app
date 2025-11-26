import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/vendor/quotation_request/site_visit_assign_employee_request.dart';
import 'package:Xception/core/model/vendor/quotation_request/site_visit_assign_employee_response.dart';
import 'package:Xception/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:Xception/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:Xception/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SiteVisitRequest {
  final String id;
  final String customerName;
  final String serviceName;
  final String requestedDate;

  SiteVisitRequest({
    required this.id,
    required this.customerName,
    required this.serviceName,
    required this.requestedDate,
  });
}

class NewRequestNotifier extends BaseChangeNotifier {
  List<VendorQuotationRequestData> requests = [];

  NewRequestNotifier() {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await apiVendorQuotationRequestList();
  }

  Future<void> apiVendorQuotationRequestList() async {
    try {
      isLoading = true;
    final response = await VendorQuotationRepository.instance.apiVendorQuotationRequestList(userData?.customerId.toString() ?? "");
      final parsed = response as VendorQuotationRequestListResponse;

      if (parsed.success == true && parsed.data != null) {
        requests = parsed.data!;
      }

      notifyListeners();
    } catch (e, stackTrace) {
      print("Error fetching quotation requests: $e");
      print(stackTrace);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    } finally {
      isLoading = false;
    }
  }

  Future<void> openDialer(String phoneNumber) async {

    try {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      if (!await launchUrl(launchUri)) {
        throw 'Could not launch $phoneNumber';
      }
    } catch(e) {
      print(e);
    }
  }
}
