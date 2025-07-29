import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/core/remote/services/service_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';

class NewRequestNotifier extends BaseChangeNotifier {
  List<VendorQuotationRequestData> requests = [];

  NewRequestNotifier() {
    initializeData();
  }

  initializeData() async {
    loadUserData();
    apiVendorQuotationRequestList();
  }

  Future<void> apiVendorQuotationRequestList() async {
    try {
    final response = await ServiceRepository().apiVendorQuotationRequestList(userData?.customerId.toString() ?? "");
      final parsed = response as VendorQuotationRequestListResponse;

      if (parsed.success == true && parsed.data != null) {
        requests = parsed.data!;

        print("parsed.data?[0].quotationId");
        print(parsed.data?[0].quotationId);
        print(parsed.data?[1].quotationId);
        print(requests[0].quotationId);
      }

      notifyListeners();
    } catch (e, stackTrace) {
      print("Error fetching quotation requests: $e");
      print(stackTrace);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }
}
