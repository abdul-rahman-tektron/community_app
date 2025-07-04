import 'package:flutter/material.dart';

class RegistrationState {
  final String? community;
  final bool acceptedPrivacyPolicy;
  final double? latitude;
  final double? longitude;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final TextEditingController communityController;
  final TextEditingController addressController;
  final TextEditingController buildingController;
  final TextEditingController blockController;

  RegistrationState({
    this.community,
    this.acceptedPrivacyPolicy = false,
    this.latitude,
    this.longitude,
    required this.nameController,
    required this.emailController,
    required this.mobileController,
    required this.passwordController,
    required this.communityController,
    required this.addressController,
    required this.buildingController,
    required this.blockController,
  });

  RegistrationState copyWith({
    String? community,
    bool? acceptedPrivacyPolicy,
    double? latitude,
    double? longitude,
  }) {
    return RegistrationState(
      community: community ?? this.community,
      acceptedPrivacyPolicy: acceptedPrivacyPolicy ?? this.acceptedPrivacyPolicy,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      nameController: nameController,
      emailController: emailController,
      mobileController: mobileController,
      passwordController: passwordController,
      communityController: communityController,
      addressController: addressController,
      buildingController: buildingController,
      blockController: blockController,
    );
  }
}
