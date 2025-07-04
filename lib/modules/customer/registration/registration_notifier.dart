import 'package:community_app/core/notifier/register_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ownerTenantRegistrationNotifierProvider =
StateNotifierProvider<RegistrationNotifier, RegistrationState>(
        (ref) => RegistrationNotifier());

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  RegistrationNotifier()
      : super(
    RegistrationState(
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      mobileController: TextEditingController(),
      passwordController: TextEditingController(),
      communityController: TextEditingController(),
      addressController: TextEditingController(),
      buildingController: TextEditingController(),
      blockController: TextEditingController(),
    ),
  );

  final dummyCommunityList = [
    'Downtown Dubai',
    'Jumeirah Village Circle',
    'Dubai Marina',
    'Business Bay',
    'Palm Jumeirah',
  ];

  final personalFormKey = GlobalKey<FormState>();
  final addressFormKey = GlobalKey<FormState>();

  void setCommunity(String? community) {
    state = state.copyWith(community: community);
  }

  void togglePrivacyPolicy() {
    state = state.copyWith(acceptedPrivacyPolicy: !state.acceptedPrivacyPolicy);
  }

  void setLatLng(double lat, double lng) {
    state = state.copyWith(latitude: lat, longitude: lng);
  }

  void disposeControllers() {
    state.nameController.dispose();
    state.emailController.dispose();
    state.mobileController.dispose();
    state.passwordController.dispose();
    state.addressController.dispose();
    state.buildingController.dispose();
    state.blockController.dispose();
  }
}
