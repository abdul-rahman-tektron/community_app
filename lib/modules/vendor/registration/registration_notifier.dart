import 'dart:io';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/login/login_request.dart';
import 'package:community_app/core/model/common/register/vendor_register_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/vendor/vendor_auth_repository.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/file_upload_helper.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:flutter/material.dart';

class VendorRegistrationNotifier extends BaseChangeNotifier {
  VendorRegistrationNotifier() {
    // Initialize controllers
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final userIdController = TextEditingController();
  final contact1Controller = TextEditingController();
  final contact2Controller = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final buildingController = TextEditingController();
  final blockController = TextEditingController();
  final tradeLicenseIdController = TextEditingController();
  final tradeLicenseExpiryDateController = TextEditingController();
  final accountNumberController = TextEditingController();
  final bankNameController = TextEditingController();
  final iBanNumberController = TextEditingController();
  final branchNameController = TextEditingController();

  File? _uploadedLicenseFile;


  String? _uploadedFileName;
  bool _acceptedPrivacyPolicy = false;
  double? _latitude;
  double? _longitude;

  int _currentStep = 1;


  void togglePrivacyPolicy() {
    acceptedPrivacyPolicy = !acceptedPrivacyPolicy;
    notifyListeners();
  }

  void updateStep(int step) {
    debugPrint('Updating step to: $step');
    currentStep = step;
    notifyListeners();
  }

  void nextStep() {
    if (_currentStep <= totalSteps) {
      updateStep(_currentStep + 1);
    } else {
      debugPrint('Already at the last step.');
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      updateStep(_currentStep - 1);
    } else {
      debugPrint('Already at the first step.');
    }
  }

  Future<void> performRegistration(BuildContext context) async {

    try {
      await CommonRepository.instance.apiUserLogin(
        LoginRequest(email: "admin@example.com", password: "password"),
      );

      final request = VendorRegisterRequest(
        email: emailController.text.trim(),
        mobile: contact1Controller.text.trim(),
        password: passwordController.text.trim(),
          communityId: 0,
        userId: userIdController.text.trim(),
        address: addressController.text.trim(),
        building: buildingController.text.trim(),
        block: blockController.text.trim(),
        latitude: latitude.toString(),
        longitude: longitude.toString(),
        name: nameController.text.trim(),
        alternateContactNo: contact2Controller.text.trim(),
        createdBy: emailController.text.trim(),
        bankDetail: VendorBankDetail(
          accountNumber: accountNumberController.text.trim(),
          bankName: bankNameController.text.trim(),
          bankBranch: branchNameController.text.trim(),
          iban: iBanNumberController.text.trim(),
        ),
        documents: [
          VendorDocumentDetails(
            documentType: 'Trade License',
            documentIdentity: int.parse(tradeLicenseIdController.text.trim()),
            documentExpiryDate: tradeLicenseExpiryDateController.text.trim().toDateTimeFromDdMmYyyy(),
            documentFile: await uploadedLicenseFile?.toBase64() ?? "",
          )
        ]
      );

      final result = await VendorAuthRepository.instance.apiVendorRegister(request);

      await _handleRegisterSuccess(result, context);
    } catch (e, stackTrace) {
      ToastHelper.showError('An error occurred. Please try again.');

      print("ee");
      print(e);
      print(stackTrace);
      notifyListeners();
    }
  }

  Future<void> _handleRegisterSuccess(dynamic result, BuildContext context) async {
    ToastHelper.showSuccess('Registration Successful');
    Navigator.of(context, rootNavigator: true).pushReplacementNamed(AppRoutes.login);
  }

  void setLatLng(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }

  Future<void> uploadImage({bool fromCamera = false}) async {
    final image = await FileUploadHelper.pickImage(fromCamera: fromCamera);

    if (image != null) {
      uploadedLicenseFile = image;
      notifyListeners();
    }
  }


  void notifyListenersData() {
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    contact1Controller.dispose();
    contact2Controller.dispose();
    passwordController.dispose();
    tradeLicenseIdController.dispose();
    tradeLicenseExpiryDateController.dispose();
    addressController.dispose();
    buildingController.dispose();
    blockController.dispose();
    super.dispose();
  }

  File? get uploadedLicenseFile => _uploadedLicenseFile;

  set uploadedLicenseFile(File? value) {
    if (_uploadedLicenseFile != value) {
      _uploadedLicenseFile = value;
      notifyListeners();
    }
  }

  String? get uploadedFileName => _uploadedFileName;

  set uploadedFileName(String? value) {
    if (_uploadedFileName != value) {
      _uploadedFileName = value;
      notifyListeners();
    }
  }

  bool get acceptedPrivacyPolicy => _acceptedPrivacyPolicy;

  set acceptedPrivacyPolicy(bool value) {
    if (_acceptedPrivacyPolicy != value) {
      _acceptedPrivacyPolicy = value;
      notifyListeners();
    }
  }

  double? get latitude => _latitude;

  set latitude(double? value) {
    if (_latitude != value) {
      _latitude = value;
      notifyListeners();
    }
  }

  double? get longitude => _longitude;

  set longitude(double? value) {
    if (_longitude != value) {
      _longitude = value;
      notifyListeners();
    }
  }

  int get totalSteps => 4;

  int get currentStep => _currentStep;
  set currentStep(int value) {
    if (_currentStep != value) {
      _currentStep = value;
      notifyListeners();
    }
  }
}
