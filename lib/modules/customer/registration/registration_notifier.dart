import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/common/dropdown/community_dropdown_response.dart';
import 'package:community_app/core/model/common/error/common_response.dart';
import 'package:community_app/core/model/common/error/error_response.dart';
import 'package:community_app/core/model/common/login/login_request.dart';
import 'package:community_app/core/model/common/register/customer_register_request.dart';
import 'package:community_app/core/remote/services/common_repository.dart';
import 'package:community_app/core/remote/services/customer/customer_auth_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:community_app/utils/router/routes.dart';
import 'package:community_app/utils/widgets/custom_stepper.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomerRegistrationNotifier extends BaseChangeNotifier {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final userIdController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final communityController = TextEditingController();
  final addressController = TextEditingController();
  final buildingController = TextEditingController();
  final blockController = TextEditingController();

  List<CommunityDropdownData> communityDropdownData = [];

  final List<CustomStepperItem> registrationSteps = [
    CustomStepperItem(title: 'Personal', icon: LucideIcons.userRound),
    CustomStepperItem(title: 'Address', icon: LucideIcons.mapPin),
  ];

  String? _selectedCommunity;
  String? _selectedCommunityId;
  bool acceptedPrivacyPolicy = false;
  double? latitude;
  double? longitude;
  int _currentStep = 1;

  CustomerRegistrationNotifier() {
    initApi();
  }

  Future<void> initApi() async {
    apiCommunityDropdown();
  }

  void setCommunity(CommunityDropdownData? value) {
    selectedCommunity = value?.name ?? "";
    selectedCommunityId = value?.communityId.toString() ?? "";
    notifyListeners();
  }

  void togglePrivacyPolicy() {
    acceptedPrivacyPolicy = !acceptedPrivacyPolicy;
    notifyListeners();
  }

  Future<void> performRegistration(BuildContext context) async {

    if(!acceptedPrivacyPolicy) {
      ToastHelper.showError("Please accept privacy policy");
      return;
    }

    try {
      await CommonRepository.instance.apiUserLogin(
        LoginRequest(email: "admin@example.com", password: "password"),
        isRegister: true,
      );

      final request = CustomerRegisterRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        mobile: mobileController.text.trim(),
        password: passwordController.text.trim(),
        communityId: int.parse(selectedCommunityId ?? "0"),
        userId: userIdController.text.trim(),
        address: addressController.text.trim(),
        building: buildingController.text.trim(),
        block: blockController.text.trim(),
        latitude: latitude.toString(),
        longitude: longitude.toString(),
        type: "C",
        customerType: "T",
        typeId: 1,
        createdBy: nameController.text.trim(),
      );

      final result = await CustomerAuthRepository.instance.apiCustomerRegister(request);

      if(result is CommonResponse && result.success == true) {
        await _handleRegisterSuccess(result, context);
      }

      if(result is CommonResponse && result.success == false) {
        ToastHelper.showError(result.message ?? 'Registration failed.');
        notifyListeners();
        return;
      }
    } catch (e) {
      ToastHelper.showError('An error occurred. Please try again.');
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

  //Community dropdown Api call
  Future<void> apiCommunityDropdown() async {
    try {
      final result = await CommonRepository.instance.apiCommunityDropdown();

      if (result is List<CommunityDropdownData>) {
        communityDropdownData = result;
        notifyListeners();
      } else {
        debugPrint("Unexpected result type from apiServiceDropDown");
      }
    } catch (e) {
      debugPrint("Error in apiServiceDropdown: $e");
    }
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    communityController.dispose();
    addressController.dispose();
    buildingController.dispose();
    blockController.dispose();
    super.dispose();
  }

  //Getter and Setter
  String? get selectedCommunity => _selectedCommunity;
  set selectedCommunity(String? value) {
    if (_selectedCommunity != value) {
      _selectedCommunity = value;
      notifyListeners();
    }
  }

  int get totalSteps => 2;

  String? get selectedCommunityId => _selectedCommunityId;
  set selectedCommunityId(String? value) {
    if (_selectedCommunityId != value) {
      _selectedCommunityId = value;
      notifyListeners();
    }
  }

  int get currentStep => _currentStep;
  set currentStep(int value) {
    if (_currentStep != value) {
      _currentStep = value;
      notifyListeners();
    }
  }
}
