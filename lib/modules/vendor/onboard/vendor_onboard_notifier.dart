import 'dart:convert';
import 'dart:io';
import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/dropdown/service_dropdown_response.dart';
import 'package:community_app/core/model/vendor/add_vendor_service/add_vendor_service_request.dart';
import 'package:community_app/core/model/vendor/service/get_all_vendor_service_response.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_auth_repository.dart';
import 'package:community_app/res/images.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    "Handyman Services": AppImages.handyMan,
    "Security & CCTV": AppImages.security,
    "Pest Control": AppImages.pestControl,
    "Appliance Repair": AppImages.applianceRepair,
    "Carpentry": AppImages.carpentry,
    "Pet Grooming": AppImages.petGrooming,
    "Laundry": AppImages.laundryService,
    "Plumbing": AppImages.plumbing,
    "Painting": AppImages.painting,
    "Cleaning": AppImages.cleaning,
    "Electric Works": AppImages.electrical,
    "AC Repair": AppImages.acRepair,
  };

  VendorOnboardNotifier(this.isEdit) {
    runWithLoadingVoid(() => initializeData());
  }

  Future<void> initializeData() async {
    await loadUserData();
    await apiServiceDropdown();
    if(isEdit ?? false) await apiGetAllVendorServices();
  }

  void setSelectedService(ServiceDropdownData service) {
    selectedService = service;

    print("selectedService.serviceId");
    print(selectedService?.serviceId);
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

  Future<void> apiAddVendorService(int serviceId) async {
    try {
      final image = await getBase64Image(serviceImagePath);
      final request = AddVendorServiceRequest(
        vendorName: userData?.name ?? "",
        vendorId: userData?.customerId ?? 0,
        serviceId: serviceId,
        service: serviceId,
        description: descriptionController.text,
        image: image,
        createdBy: userData?.name ?? "",
      );

      print("Adding service request: ${request.toJson()}");
      final result = await VendorAuthRepository.instance.apiAddVendorService(request);
      print("Result: $result");

      if (result is List<ServiceDropdownData>) {
        serviceData = result;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error in apiAddVendorService: $e");
    }
  }

  Future<void> apiUpdateVendorService(int serviceId, String serviceName) async {
    try {
      final image = await getBase64Image(serviceImagePath);
      final request = AddVendorServiceRequest(
        vendorName: userData?.name ?? "",
        vendorId: userData?.customerId ?? 0,
        serviceId: serviceId,
        service: serviceId,
        description: descriptionController.text,
        image: image,
        createdBy: userData?.name ?? "",
      );

      print("Updating service request: ${request.toJson()}");
      final result = await VendorAuthRepository.instance.apiUpdateVendorService(request);
      print("Result: $result");

      if (result is List<ServiceDropdownData>) {
        serviceData = result;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error in apiUpdateVendorService: $e");
    }
  }


  Future<String?> getBase64Image(String? serviceImagePath) async {
    if (serviceImagePath == null) return null;

    if (serviceImagePath.startsWith("assets/")) {
      // Asset → convert to base64
      return await fileToBase64(serviceImagePath, isAsset: true);
    } else if (_isBase64(serviceImagePath)) {
      // Already base64 → return directly
      return serviceImagePath;
    } else {
      // File path → convert to base64
      return await fileToBase64(serviceImagePath);
    }
  }

  bool _isBase64(String str) {
    final base64RegEx = RegExp(r'^[A-Za-z0-9+/=]+\Z');
    return str.isNotEmpty &&
        str.length % 4 == 0 &&
        base64RegEx.hasMatch(str.replaceAll("\n", "").replaceAll("\r", ""));
  }

  Future<void> apiGetAllVendorServices() async {
    try {
      final result = await VendorAuthRepository.instance
          .apiGetAllVendorServices((userData?.customerId ?? 0).toString());

      if (result is List<GetAllVendorServiceResponse>) {
        for (final service in result) {
          final matchedDropdown = serviceData.firstWhere(
                (s) => s.serviceId == service.serviceId,
            orElse: () => ServiceDropdownData(serviceId: service.serviceId, serviceName: service.service),
          );

          completedServices[matchedDropdown] = {
            'description': service.description ?? '',
            'imagePath': service.image ?? staticServiceImages[matchedDropdown.serviceName ?? ""],
          };
        }
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiGetAllVendorServices");
      }
    } catch (e) {
      debugPrint("Error in apiGetAllVendorServices: $e");
    }
  }


  Future<String?> fileToBase64(String? path, {bool isAsset = false}) async {
    if (path == null) return null;

    try {
      if (isAsset) {
        final byteData = await rootBundle.load(path);
        return base64Encode(byteData.buffer.asUint8List());
      } else {
        final bytes = await File(path).readAsBytes();
        return base64Encode(bytes);
      }
    } catch (e) {
      debugPrint("fileToBase64 error: $e");
      return null;
    }
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

    // Determine if this is an update or a new addition
    final isExistingService = completedServices.containsKey(selectedService);

    // Prepare serviceId safely
    final serviceId = int.tryParse("${selectedService?.serviceId}") ?? 0;
    final serviceName = selectedService?.serviceName ?? "";

    // Call API first
    if (isEdit ?? false) {
      if (isExistingService) {
        apiUpdateVendorService(serviceId, serviceName); // Pass serviceId explicitly
      } else {
        apiAddVendorService(serviceId); // Pass serviceId explicitly
      }
    } else {
      apiAddVendorService(serviceId); // Fresh onboarding
    }

    // Save in local completed map AFTER API call
    completedServices[selectedService!] = {
      'description': descriptionController.text,
      'imagePath': serviceImagePath,
    };

    // Close the section
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
