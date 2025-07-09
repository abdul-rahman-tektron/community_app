import 'dart:io';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/login/login_request.dart';
import 'package:community_app/core/model/register/customer_register_request.dart';
import 'package:community_app/core/model/register/vendor_register_request.dart';
import 'package:community_app/core/remote/services/auth_repository.dart';
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

  final dummyCommunityList = [
    'Downtown Dubai',
    'Jumeirah Village Circle',
    'Dubai Marina',
    'Business Bay',
    'Palm Jumeirah',
  ];

  String? _community;
  String? _uploadedFileName;
  bool _acceptedPrivacyPolicy = false;
  double? _latitude;
  double? _longitude;

  void setCommunity(String? value) {
    community = value;
    notifyListeners();
  }

  void togglePrivacyPolicy() {
    acceptedPrivacyPolicy = !acceptedPrivacyPolicy;
    notifyListeners();
  }

  Future<void> performRegistration(BuildContext context) async {

    try {
      await AuthRepository().apiUserLogin(
        LoginRequest(email: "admin@example.com", password: "password"),
      );

      print("Object Reached");
      final request = VendorRegisterRequest(
        email: emailController.text.trim(),
        mobile: contact1Controller.text.trim(),
        password: passwordController.text.trim(),
        communityId: 1,
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

      print("Object Reached 1");

      final result = await AuthRepository().apiVendorRegister(request);

      print("Object Reached 2");

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

  String? get community => _community;

  set community(String? value) {
    if (_community != value) {
      _community = value;
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
}
