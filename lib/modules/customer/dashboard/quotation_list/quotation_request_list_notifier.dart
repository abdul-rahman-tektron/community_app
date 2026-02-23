import 'package:Xception/core/base/base_notifier.dart';
import 'package:Xception/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:Xception/core/model/customer/quotation/quotation_request_list_response.dart';
import 'package:Xception/core/remote/services/common_repository.dart';
import 'package:Xception/core/remote/services/customer/customer_dashboard_repository.dart';
import 'package:Xception/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class QuotationRequestListNotifier extends BaseChangeNotifier {
  final List<int> _selected = [];
  List<CustomerRequestListData> requests = [];
  List<ServiceDropdownData> serviceDropdownData = [];

  QuotationRequestListNotifier() {
    initializeData();
  }

  initializeData() async {
    await loadUserData();
    await Future.wait([apiServiceDropdown(), apiQuotationRequestList()]);
  }

  Future<void> apiQuotationRequestList() async {
    try {
      isLoading = true;
      notifyListeners();

      final parsed =
          await CustomerDashboardRepository.instance.apiQuotationRequestList(
                userData?.customerId.toString() ?? "0",
              )
              as CustomerRequestListResponse;

      if (parsed.success == true && parsed.data != null) {
        requests = parsed.data!;
      }
    } catch (e, stackTrace) {
      print("Error fetching quotation requests: $e");
      print("Stack: $stackTrace");
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getServiceNameById(int? serviceId) {
    final service = serviceDropdownData.firstWhere(
      (s) => s.serviceId == serviceId,
      orElse: () => ServiceDropdownData(serviceId: 0, serviceName: "Unknown"),
    );
    return service.serviceName ?? "Unknown";
  }

  //Service dropdown Api call
  Future<void> apiServiceDropdown() async {
    try {
      final result = await CommonRepository.instance.apiServiceDropdown();

      if (result is List<ServiceDropdownData>) {
        serviceDropdownData = result;
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiServiceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiServiceDropdown: $e");
    }
  }

  String? getQuotationBadgeText(CustomerRequestListData request) {
    // Show only for Initiated jobs
    if ((request.status ?? "").trim() != "Initiated") return null;

    final dist = request.distributions ?? [];

    // 1) Customer didn't select vendor
    if (dist.isEmpty) return "Vendor not selected";

    // 0) If any quotation is rejected (customer/vendor) => show Rejected
    for (final d in dist) {
      final String status = (d is Map)
          ? (d["status"] ?? "").toString().trim()
          : ((d.status ?? "").toString().trim());

      final int? statusId = (d is Map)
          ? (d["statusId"] is int ? d["statusId"] as int : int.tryParse("${d["statusId"]}"))
          : d.statusId;

      final bool isRejected =
          statusId == 3 || status.toLowerCase().contains("rejected");

      if (isRejected) return "Quotation rejected";
    }

    // 2) Count vendors who provided quotation
    int providedCount = 0;

    for (final d in dist) {
      final String status = (d is Map)
          ? (d["status"] ?? "").toString().trim()
          : ((d.status ?? "").toString().trim());

      final int? statusId = (d is Map)
          ? (d["statusId"] is int ? d["statusId"] as int : int.tryParse("${d["statusId"]}"))
          : d.statusId;

      final bool isProvided = status == "Quotation Submitted" || statusId == 7;
      if (isProvided) providedCount++;
    }

    if (providedCount > 0) return "$providedCount Quotation provided";

    // 3) Vendors exist but not provided yet
    return "Quotation not provided yet";
  }

  Color? getQuotationBadgeBg(CustomerRequestListData request) {
    final text = getQuotationBadgeText(request);
    if (text == null) return null;

    if (text == "Vendor not selected") return const Color(0xFFFFF3E0);

    if (text.toLowerCase().contains("rejected")) {
      return const Color(0xFFFFEBEE); // light red background
    }

    if (text.contains("Quotation provided")) return const Color(0xFFE8F5E9);

    return const Color(0xFFE3F2FD);
  }

  Color? getQuotationBadgeTextColor(CustomerRequestListData request) {
    final text = getQuotationBadgeText(request);
    if (text == null) return null;

    if (text == "Vendor not selected") return const Color(0xFFE65100);

    if (text.toLowerCase().contains("rejected")) {
      return const Color(0xFFC62828); // red
    }

    if (text.contains("Quotation provided")) return const Color(0xFF1B5E20);

    return const Color(0xFF0D47A1);
  }

  bool isSelected(int index) => _selected.contains(index);

  void toggle(int index) {
    if (_selected.contains(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    notifyListeners();
  }

  List<int> get selectedIndexes => _selected;
}
