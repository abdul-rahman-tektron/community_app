import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final vendorRegistrationNotifierProvider = ChangeNotifierProvider((ref) => RegistrationNotifier());

class RegistrationNotifier extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final mobile2Controller = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final buildingController = TextEditingController();
  final blockController = TextEditingController();

  String? selectedCommunity;
  bool acceptedPrivacyPolicy = false;

  void setCommunity(String? community) {
    if (community != selectedCommunity) {
      selectedCommunity = community;
      notifyListeners();
    }
  }

  void togglePrivacyPolicy(bool? value) {
    acceptedPrivacyPolicy = value ?? false;
    notifyListeners();
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    mobile2Controller.dispose();
    passwordController.dispose();
    addressController.dispose();
    buildingController.dispose();
    blockController.dispose();
  }
}
