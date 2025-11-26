import 'package:Xception/core/base/base_notifier.dart';
import 'package:flutter/material.dart';

class SavedCardsNotifier extends BaseChangeNotifier {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  SavedCardsNotifier(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    runWithLoadingVoid(() async {
      _initializeData();
    });
  }

  void _initializeData() {
    // Initialize fields with user data if needed
  }

  Future<void> saveData(BuildContext context) async {
    runWithLoadingVoid(() => saveApiCall(context));
  }

  Future<void> saveApiCall(BuildContext context) async {
    final cardName = fullNameController.text.trim();
    final cardNumber = cardNumberController.text.trim();
    final expiryDate = expiryDateController.text.trim();
    final cvv = cvvController.text.trim();

    // Example API call placeholder
    // await PaymentRepository().apiSaveCard(...);
  }

  @override
  void dispose() {
    fullNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }
}

// validators in Validations class
// static String? validateCardNumber(String? value) { ... }
// static String? validateExpiryDate(String? value) { ... }
// static String? validateCVV(String? value) { ... }