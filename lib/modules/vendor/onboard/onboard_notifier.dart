import 'dart:convert';
import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/core/model/vendor/add_vendor_service/add_vendor_service_request.dart';
import 'package:community_app/core/remote/services/service_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OnboardNotifier extends BaseChangeNotifier {
  ServiceDropdownData? selectedService;
  final TextEditingController descriptionController = TextEditingController();
  String? serviceImagePath;
  String? logoPath;

  List<ServiceDropdownData> serviceData = [];

  // Store completed services with their data
  final Map<ServiceDropdownData, Map<String, String?>> completedServices = {};

  OnboardNotifier() {
    initializeData();
  }

  void initializeData() async {
    loadUserData();
    await apiServiceDropdown();
  }

  void setSelectedService(ServiceDropdownData service) {
    selectedService = service;
    // Load data if already completed
    if (completedServices.containsKey(service)) {
      descriptionController.text = completedServices[service]!['description'] ?? '';
      serviceImagePath = completedServices[service]!['imagePath'];
    } else {
      descriptionController.clear();
      serviceImagePath = null;
    }
    notifyListeners();
  }

  //Service dropdown Api call
  Future<void> apiServiceDropdown() async {
    try {
      final result = await ServiceRepository().apiServiceDropdown();

      if (result is List<ServiceDropdownData>) {
        serviceData = result;
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiServiceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiServiceDropdown: $e");
    }
  }

  //Service dropdown Api call
  Future<void> apiAddVendorService() async {
    try {
      final result = await ServiceRepository().apiAddVendorService(AddVendorServiceRequest(
        vendorName: userData?.name ?? "",
        vendorId: userData?.customerId ?? 0,
        service: selectedService?.serviceId ?? 0,
        serviceId: selectedService?.serviceId ?? 0,
        description: descriptionController.text,
        image: await fileToBase64(serviceImagePath),
        createdBy: userData?.name ?? "",
      ));

      if (result is List<ServiceDropdownData>) {
        serviceData = result;
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiServiceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiServiceDropdown: $e");
    }
  }

  Future<String?> fileToBase64(String? path) async {
    if (path == null) return null;
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }

  Future<void> pickServiceImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      serviceImagePath = picked.path;
      notifyListeners();
    }
  }

  Future<void> pickLogo() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      logoPath = picked.path;
      notifyListeners();
    }
  }

  File getFileFromPath(String path) => File(path);

  /// When Done is clicked - save service details and close the card
  void doneWithService() {
    if (selectedService == null) return;

    if (descriptionController.text.isEmpty) {
      ToastHelper.showError("Please provide a description for ${selectedService?.serviceName ?? ""}");
      return;
    }
    if (serviceImagePath == null) {
      ToastHelper.showError("Please upload the service image(s) for ${selectedService?.serviceName ?? ""}");
      return;
    }

    completedServices[selectedService!] = {
      'description': descriptionController.text,
      'imagePath': serviceImagePath,
    };

    apiAddVendorService();

    // Close the section after saving
    selectedService = null;
    notifyListeners();
  }

  /// Check if a service is completed
  bool isServiceCompleted(ServiceDropdownData service) {
    return completedServices.containsKey(service);
  }

  /// Final submit validation
  void submit() {
    if (completedServices.isEmpty) {
      ToastHelper.showError("Please fill in all the required details.");
      return;
    }
    if (logoPath == null) {
      ToastHelper.showError("Please upload the company logo.");
      return;
    }

    // Proceed with submission
    print("Completed Services: $completedServices");
    print("Logo: $logoPath");
  }
}
