import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/vendor_quotation_request_list.dart';
import 'package:community_app/core/remote/services/vendor/vendor_quotation_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
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
    loadUserData();
    apiVendorQuotationRequestList();
  }

  Future<void> apiVendorQuotationRequestList() async {
    try {
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
    }
  }

  Future<void> openDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw 'Could not launch $phoneNumber';
    }
  }
}
