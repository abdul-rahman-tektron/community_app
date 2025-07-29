import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/top_vendors/top_vendors_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_request.dart';
import 'package:community_app/core/remote/services/service_repository.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

class TopVendorsNotifier extends BaseChangeNotifier {
  final List<int> _selected = [];

  int serviceId = 0;
  int jobId = 0;

  List<TopVendorResponse> topVendors = [];

  TopVendorsNotifier({int? jobId, int? serviceId}) {
    this.serviceId = serviceId ?? 0;
    this.jobId = jobId ?? 0;
    initializeData();
  }

  initializeData() async {
    await apiTopVendors();
  }


  Future<void> apiQuotationRequest(BuildContext context) async {
    try {
      final request = QuotationRequestRequest(
        jobId: jobId,
        serviceId: serviceId,
        vendorId: selectedVendorIds.isNotEmpty ? selectedVendorIds.first : null,
        customerId: userData?.customerId ?? 0,
        active: true,
        createdBy: userData?.name ?? "",
        status: "Pending",
        jobQuotationRequestItems: selectedVendorIds
            .map((id) => JobQuotationRequestItem(vendorId: id))
            .toList(),
      );

      final result = await ServiceRepository().apiQuotationRequest(request);

      print("result Result of Quotation Request");
      print(result);
      await _handleSubmitRequest(context, result);
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }


  List<int> get selected => _selected;
  int get selectedCount => _selected.length;
  int get totalVendors => 5; // Replace with actual API count when integrated

  List<int> get selectedVendorIds =>
      _selected.map((index) => topVendors[index].vendorId ?? 0).toList();

  bool isSelected(int index) => _selected.contains(index);

  void toggle(int index) {
    if (_selected.contains(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selected.clear();
    notifyListeners();
  }

  Future<void> apiTopVendors() async {
    try {

      final result = await ServiceRepository().apiTopVendorList(serviceId.toString());

      print("result");
      print(result);
      await _handleCreatedJobSuccess(result);
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
      notifyListeners();
    }
  }

  Future<void> _handleCreatedJobSuccess(dynamic result) async {
    print("Result Data");
    print(result);
    topVendors = result;
    notifyListeners();
  }

  Future<void> _handleSubmitRequest(BuildContext context, dynamic result) async {
    print("Result Data");
    print(result);
    Navigator.pushNamed(context, AppRoutes.newServicesConfirmation, arguments: "67534670");
    notifyListeners();
  }
}


class Vendor {
  final String name;
  final String location;
  final String distance;
  final double rating;
  final int reviews;
  final String image;

  Vendor({
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.image,
  });
}