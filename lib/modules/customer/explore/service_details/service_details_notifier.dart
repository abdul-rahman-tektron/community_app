import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/explore/service_detail_request.dart';
import 'package:community_app/core/model/customer/explore/service_detail_response.dart';
import 'package:community_app/core/remote/services/customer/customer_explore_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class ServiceDetailsNotifier extends BaseChangeNotifier {
  // Description

  int? serviceId;
  int? vendorId;

  ServiceDetailData? serviceDetail;

  bool _isLoading = true;

  final double _rating = 4.2;

  ServiceDetailsNotifier({
    this.serviceId,
    this.vendorId
  }) {
    runWithLoadingVoid(() => initializeData());
  }

  initializeData() async {
    await loadUserData();
    await apiServiceDetails();
  }


  bool _showFullDescription = false;
  bool get showFullDescription => _showFullDescription;

  Future<void> apiServiceDetails() async {
    try {
      final result = await CustomerExploreRepository.instance.apiServiceDetails(
        ServiceDetailRequest(vendorId: vendorId ?? 0, serviceId: serviceId ?? 0),
      );

      if (result is ServiceDetailResponse) {
        serviceDetail = result.data;
        notifyListeners();
      }

      description = serviceDetail?.vendors?[0].description ?? "";

    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleDescription() {
    _showFullDescription = !_showFullDescription;
    notifyListeners();
  }

  String? _description;

  String? get description => _description;

  set description(String? value) {
    if (_description != value) {
      _description = value;
      notifyListeners();
    }
  }
  int currentPage = 0;

  double get rating => _rating;
}