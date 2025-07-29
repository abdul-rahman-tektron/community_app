import 'dart:convert';
import 'dart:io';

import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/login/login_response.dart';
import 'package:community_app/core/model/common/user/update_user_request.dart';
import 'package:community_app/core/model/common/user/update_user_response.dart';
import 'package:community_app/core/remote/services/auth_repository.dart';
import 'package:community_app/utils/extensions.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/storage/hive_storage.dart';
import 'package:flutter/material.dart';

class EditProfileNotifier extends BaseChangeNotifier {


  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailAddressController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController blockController = TextEditingController();

  double? latitude;
  double? longitude;

  File? _uploadedUserProfile;
  String? _uploadedProfileName;


  //Functions
  EditProfileNotifier(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    runWithLoadingVoid(() async {
      await loadUserData();
      _initializeData(context);
    },);
  }


  void _initializeData(BuildContext context) {
    fullNameController.text = userData?.name ?? "";
    mobileNumberController.text = userData?.mobile ?? "";
    emailAddressController.text = userData?.email ?? "";
    addressController.text = userData?.address ?? "";
    buildingController.text = userData?.building ?? "";
    blockController.text = userData?.block ?? "";
  }

  Future<void> saveData(BuildContext context) async {
    runWithLoadingVoid(() => saveApiCall(context));
  }

  Future<void> saveApiCall(BuildContext context) async {

    final updateProfileRequest = UpdateUserRequest(
      email: emailAddressController.text,
      password: userData?.password ?? "test",
      address: addressController.text,
      latitude: latitude?.toString() ?? "0",
      longitude: longitude?.toString() ?? "0",
      block: blockController.text,
      building: buildingController.text,
      customerId: userData?.customerId ?? 0,
      mobile: mobileNumberController.text,
      name: fullNameController.text,
      userId: userData?.userId ?? "",
      createdBy: userData?.name ?? "",
      image: await uploadedUserProfile?.toBase64() ?? "",
    );

    try {
    final result = await AuthRepository().apiUpdateUserProfile(
        userData?.customerId.toString() ?? "0",
        updateProfileRequest,
      );

    if (result is UpdateUserResponse) {
      ToastHelper.showSuccess("Customer updated successfully");

      final existingLogin = loginResponseFromJson(HiveStorageService.getUserData() ?? ""); // LoginResponse

      final updated = result.data; // UserData

      final updatedLogin = LoginResponse(
        email: updated?.email ?? existingLogin.email,
        token: existingLogin.token,
        // preserve token
        customerId: updated?.customerId ?? existingLogin.customerId,
        typeId: updated?.typeId ?? existingLogin.typeId,
        type: updated?.type ?? existingLogin.type,
        name: updated?.name ?? existingLogin.name,
        mobile: updated?.mobile ?? existingLogin.mobile,
        landline: updated?.landline ?? existingLogin.landline,
        alternateContactNo: updated?.alternateContactNo ?? existingLogin.alternateContactNo,
        communityId: updated?.communityId ?? existingLogin.communityId,
        building: updated?.building ?? existingLogin.building,
        block: updated?.block ?? existingLogin.block,
        address: updated?.address ?? existingLogin.address,
        latitude: updated?.latitude ?? existingLogin.latitude,
        longitude: updated?.longitude ?? existingLogin.longitude,
        blacklisted: updated?.blacklisted ?? existingLogin.blacklisted,
        settlementPercentage: updated?.settlementPercentage ?? existingLogin.settlementPercentage,
        deleted: updated?.deleted ?? existingLogin.deleted,
        active: updated?.active ?? existingLogin.active,
        userId: updated?.userId ?? existingLogin.userId,
        password: updated?.password ?? existingLogin.password,
        loginEnable: updated?.loginEnable ?? existingLogin.loginEnable,
        customerType: updated?.customerType ?? existingLogin.customerType,
      );

      // Save merged LoginResponse back to Hive
      HiveStorageService.setUserData(jsonEncode(updatedLogin));

      Navigator.pop(context);
    }
    } catch(e) {
      ToastHelper.showError('An error occurred. Please try again.');
    }

  }

  void setLatLng(double lat, double lng) {
    latitude = lat;
    longitude = lng;
    notifyListeners();
  }


  //Getter And Setter
  File? get uploadedUserProfile => _uploadedUserProfile;

  set uploadedUserProfile(File? value) {
    if (_uploadedUserProfile != value) {
      _uploadedUserProfile = value;
      notifyListeners();
    }
  }

  String? get uploadedProfileName => _uploadedProfileName;

  set uploadedProfileName(String? value) {
    if (_uploadedProfileName != value) {
      _uploadedProfileName = value;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileNumberController.dispose();
    emailAddressController.dispose();
    super.dispose();
  }
}