import 'package:community_app/core/base/base_notifier.dart';
import 'package:flutter/material.dart';

class PaymentNotifier extends BaseChangeNotifier {
  bool isCardSelected = true;
  bool saveCard = false;

  final promoCodeController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  final cardHolderNameController = TextEditingController();

  bool isTermsExpanded = false;

  void toggleTermsExpanded() {
    isTermsExpanded = !isTermsExpanded;
    notifyListeners();
  }

  void togglePaymentMethod(bool value) {
    isCardSelected = value;
    notifyListeners();
  }

  void toggleSaveCard() {
    saveCard = !saveCard;
    notifyListeners();
  }
}
