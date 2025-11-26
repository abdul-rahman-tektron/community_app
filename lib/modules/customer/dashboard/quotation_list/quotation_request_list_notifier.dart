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
