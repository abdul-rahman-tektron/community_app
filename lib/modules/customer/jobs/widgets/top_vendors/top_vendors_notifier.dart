import 'dart:math';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/customer/job/job_status_tracking/update_job_status_request.dart';
import 'package:community_app/core/model/customer/top_vendors/top_vendors_response.dart';
import 'package:community_app/core/model/vendor/quotation_request/quotation_request_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_dashboard_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_jobs_repository.dart';
import 'package:community_app/utils/helpers/common_utils.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/location_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class TopVendorsNotifier extends BaseChangeNotifier {
  final List<int> _selected = [];
  LocationData? currentLocation;

  /// Store computed distances keyed by vendorId
  final Map<int, double?> vendorDistances = {};
  final Map<int, String> vendorCleanAddresses = {};

  int serviceId = 0;
  int jobId = 0;
  int? vendorId;
  String? vendorName;

  List<TopVendorResponse> topVendors = [];

  TopVendorsNotifier(BuildContext context, {int? jobId, int? serviceId, this.vendorId , this.vendorName}) {
    this.serviceId = serviceId ?? 0;
    this.jobId = jobId ?? 0;
    initializeData(context);
  }

  initializeData(BuildContext context) async {
    isLoading = true;
    bool serviceEnabled = await LocationHelper.isServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await LocationHelper.requestService();
      if (!serviceEnabled) {
        print("Location service not enabled");
        return;
      }
    }
    PermissionStatus permission = await LocationHelper.checkAndRequestPermission();
    if (permission != PermissionStatus.granted) {
      print("Location permission denied");
      return;
    }

    await loadUserData();

    if(vendorId != null) {
      apiQuotationRequest(context);
    } else {
      await apiTopVendors();
    }

    isLoading = false;
    notifyListeners();
  }


  Future<void> apiQuotationRequest(BuildContext context) async {
    try {
      final request = QuotationRequestRequest(
        jobId: jobId,
        serviceId: serviceId,
        vendorId: selectedVendorIds.isNotEmpty ? selectedVendorIds.first : vendorId,
        vendorName: selectedVendorNames.isNotEmpty ? selectedVendorNames.first : vendorName,
        customerId: userData?.customerId ?? 0,
        fromCustomerId: userData?.customerId ?? 0,
        active: true,
        createdBy: userData?.name ?? "",
        status: "Pending",
        jobQuotationRequestItems: selectedVendorIds.isNotEmpty ? selectedVendorIds
            .map((id) => JobQuotationRequestItem(vendorId: id))
            .toList() : [JobQuotationRequestItem(vendorId: vendorId)],
      );

      final result = await CustomerDashboardRepository.instance.apiQuotationRequest(request);

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

  Future<void> apiUpdateJobStatus(int? statusId) async {
    if (statusId == null) return;
    try {
      notifyListeners();

      final parsed = await CommonRepository.instance.apiUpdateJobStatus(
        UpdateJobStatusRequest(jobId: jobId,
            statusId: statusId,
            createdBy: userData?.name ?? "",
            vendorId: userData?.customerId ?? 0),
      );
    } catch (e, stackTrace) {
      print("❌ Error updating job status: $e");
      print("Stack: $stackTrace");
    } finally {
      notifyListeners();
    }
  }


  List<int> get selected => _selected;
  int get selectedCount => _selected.length;
  int get totalVendors => 5; // Replace with actual API count when integrated

  List<int> get selectedVendorIds =>
      _selected.map((index) => topVendors[index].vendorId ?? 0).toList();

  List<String> get selectedVendorNames =>
      _selected.map((index) => topVendors[index].vendorName ?? '').toList();

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

  String parseCleanAddress(String address) {
    return address.split("{").first.trim();
  }

  Map<String, double?> parseLatLng(String address) {
    double? lat;
    double? lng;

    if (address.contains("{")) {
      final coords = address.split("{").last.replaceAll(RegExp(r"[{} ]"), "");
      final latLngParts = coords.split(",");
      for (var part in latLngParts) {
        if (part.contains("Latitude:")) {
          lat = double.tryParse(part.split(":")[1]);
        } else if (part.contains("Longitude:")) {
          lng = double.tryParse(part.split(":")[1]);
        }
      }
    }
    return {"lat": lat, "lng": lng};
  }

  double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371; // Earth radius in km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);

  Future<void> apiTopVendors() async {
    try {
      final result = await CustomerJobsRepository.instance.apiTopVendorList(serviceId.toString());
      await _handleCreatedJobSuccess(result);
      await calculateVendorDistances();
    } catch (e) {
      print("result error");
      print(e);
      ToastHelper.showError('An error occurred. Please try again.');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> calculateVendorDistances() async {
    print("===== [calculateVendorDistances] START =====");

    LocationData? userLocation;

    try {
      print("[DEBUG] Requesting user location...");
      // Add a timeout to avoid hanging indefinitely
      userLocation = await LocationHelper.getCurrentLocation().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("[ERROR] Location request timed out");
          return null;
        },
      );
      print("[DEBUG] Location request completed");
    } catch (e, st) {
      print("[ERROR] Failed to get location: $e");
      print(st);
    }

    if (userLocation == null) {
      print("[ERROR] User location is null (permissions denied, GPS off, or timeout)");
      print("===== [calculateVendorDistances] END =====");
      return;
    }

    print("[INFO] User location: Lat=${userLocation.latitude}, Lng=${userLocation.longitude}");
    print("-----");

    for (var vendor in topVendors) {
      print("[VENDOR] Processing: ${vendor.vendorName}");

      if (vendor.address != null) {
        try {
          final cleanAddress = parseCleanAddress(vendor.address!);
          print("[INFO] Parsed Address: $cleanAddress");

          final coords = parseLatLng(vendor.address!);
          final lat = coords["lat"];
          final lng = coords["lng"];
          print("[INFO] Parsed Lat: $lat, Lng: $lng");

          vendorCleanAddresses[vendor.vendorId ?? -1] = cleanAddress;

          if (lat != null && lng != null) {
            final dist = calculateDistanceKm(
              userLocation.latitude!,
              userLocation.longitude!,
              lat,
              lng,
            );
            vendorDistances[vendor.vendorId ?? -1] = dist;
            print("[SUCCESS] Distance calculated: ${dist.toStringAsFixed(2)} km");
          } else {
            print("[WARN] Could not parse coordinates for vendor: ${vendor.vendorName}");
            vendorDistances[vendor.vendorId ?? -1] = null;
          }
        } catch (e, st) {
          print("[ERROR] Failed processing vendor ${vendor.vendorName}: $e");
          print(st);
        }
      } else {
        print("[WARN] Vendor address is null for vendor: ${vendor.vendorName}");
        vendorDistances[vendor.vendorId ?? -1] = null;
      }

      print("-----");
    }

    try {
      // Sort vendors by distance, null distances at end
      topVendors.sort((a, b) {
        final aDist = vendorDistances[a.vendorId ?? -1] ?? double.infinity;
        final bDist = vendorDistances[b.vendorId ?? -1] ?? double.infinity;
        return aDist.compareTo(bDist);
      });
      print("[INFO] Vendors sorted by distance");
    } catch (e, st) {
      print("[ERROR] Failed to sort vendors: $e");
      print(st);
    }

    print("===== [calculateVendorDistances] END =====");
    notifyListeners();
  }


  Future<void> _handleCreatedJobSuccess(dynamic result) async {
    print("Result Data");
    print(result);
    topVendors = result;
    notifyListeners();
  }

  Future<void> _handleSubmitRequest(BuildContext context, dynamic result) async {
    await apiUpdateJobStatus(AppStatus.quotationRequested.id);
    Navigator.pushNamed(context, AppRoutes.newServicesConfirmation, arguments: jobId.toString());
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