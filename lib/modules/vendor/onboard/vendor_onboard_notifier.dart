import 'dart:convert';
import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/core/model/vendor/add_vendor_service/add_vendor_service_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_auth_repository.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class VendorOnboardNotifier extends BaseChangeNotifier {
  ServiceDropdownData? selectedService;
  final TextEditingController descriptionController = TextEditingController();
  String? serviceImagePath;
  String? logoPath;

  bool? isEdit;

  List<ServiceDropdownData> serviceData = [];

  // Store completed services with their data
  final Map<ServiceDropdownData, Map<String, String?>> completedServices = {};

  final Map<String, String> staticDescriptions = {
    "Handyman Services": "Quick and reliable handyman services for repairs, installations, and general maintenance at your home or office.",
    "Security & CCTV": "Trusted security and CCTV solutions including installation, monitoring, and system maintenance for safety and peace of mind.",
    "Pest Control": "Safe and effective pest control treatments to eliminate insects, rodents, and termites, keeping your space clean and healthy.",
    "Appliance Repair": "Professional repair services for home appliances like refrigerators, washing machines, ovens, and more with reliable results.",
    "Carpentry": "Custom carpentry services for furniture, fittings, and home improvements, crafted with precision and quality workmanship.",
    "Pet Grooming": "Complete pet grooming services including bathing, trimming, and care to keep your pets clean, healthy, and comfortable.",
    "Laundry": "Convenient laundry services with washing, ironing, and dry cleaning to keep your clothes fresh, clean, and neatly pressed.",
    "Plumbing": "Expert plumbing solutions for leak repairs, pipe installations, bathroom fittings, and water system maintenance with quick service.",
    "Painting": "High-quality painting services for interiors and exteriors with professional finishing that refreshes and brightens your space.",
    "Cleaning": "Thorough cleaning services for homes, offices, and commercial spaces, ensuring a spotless, hygienic, and welcoming environment.",
    "Electric Works": "Certified electrical works for wiring, lighting, installations, and repairs with safe, reliable, and professional service.",
    "AC Repair": "Specialized AC repair and maintenance services to keep your air conditioning systems efficient, reliable, and cooling properly.",
  };

  final Map<String, String> staticServiceImages = {
    "Handyman Services": AppImages.loginImage,
    "Security & CCTV": AppImages.loginImage,
    "Pest Control": AppImages.loginImage,
    "Appliance Repair": AppImages.loginImage,
    "Carpentry": AppImages.loginImage,
    "Pet Grooming": AppImages.loginImage,
    "Laundry": AppImages.loginImage,
    "Plumbing": AppImages.loginImage,
    "Painting": AppImages.loginImage,
    "Cleaning": AppImages.loginImage,
    "Electric Works": AppImages.loginImage,
    "AC Repair": AppImages.loginImage,
  };

  VendorOnboardNotifier(this.isEdit) {
    initializeData();
  }

  void initializeData() async {
    loadUserData();
    await apiServiceDropdown();
    if(isEdit ?? false) await apiGetAllVendorServices();
  }

  void setSelectedService(ServiceDropdownData service) {
    selectedService = service;

    if (completedServices.containsKey(service)) {
      descriptionController.text = completedServices[service]!['description'] ?? '';
      serviceImagePath = completedServices[service]!['imagePath'];
    } else {
      descriptionController.text = staticDescriptions[service.serviceName ?? ""] ?? '';
      serviceImagePath = staticServiceImages[service.serviceName ?? ""];
    }

    notifyListeners();
  }



  //Service dropdown Api call
  Future<void> apiServiceDropdown() async {
    try {
      final result = await CommonRepository.instance.apiServiceDropdown();

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
      final result = await VendorAuthRepository.instance.apiAddVendorService(AddVendorServiceRequest(
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

  Future<void> apiGetAllVendorServices() async {
    try {
      final result = await VendorAuthRepository.instance.apiGetAllVendorServices((userData?.customerId ?? 0).toString());

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
  void submit(BuildContext context) async {
    if (completedServices.isEmpty) {
      ToastHelper.showError("Please fill in all the required details.");
      return;
    }
    // if (logoPath == null) {
    //   ToastHelper.showError("Please upload the company logo.");
    //   return;
    // }

    // Proceed with submission
    print("Completed Services: $completedServices");
    print("Logo: $logoPath");
    await HiveStorageService.setOnboardingCompleted(true);

    Navigator.pushNamed(context, AppRoutes.vendorBottomBar);
  }
}
