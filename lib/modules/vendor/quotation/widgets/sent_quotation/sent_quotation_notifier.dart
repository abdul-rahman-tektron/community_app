import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class SentQuotationNotifier extends BaseChangeNotifier {
  List<VendorQuotationRequestData> quotations = [];

  SentQuotationNotifier() {
    initializeData();
  }

  Future<void> initializeData() async {
    await loadUserData();
    await fetchSentQuotations(userData?.customerId ?? 0);
  }

  Future<void> fetchSentQuotations(int? vendorId) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await VendorQuotationRepository.instance.apiVendorQuotationRequestList(vendorId?.toString() ?? "0");
      if (result is VendorQuotationRequestListResponse && result.success == true) {
        quotations = result.data ?? [];
      } else {
        quotations = [];
      }
    } catch (e) {
      quotations = [];
      ToastHelper.showError('Failed to fetch quotations.');
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
