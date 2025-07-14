import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final spaced = digitsOnly.replaceAllMapped(RegExp(r".{1,4}"), (match) => "${match.group(0)} ").trimRight();

    final newSelectionIndex = spaced.length.clamp(0, spaced.length);

    return TextEditingValue(
      text: spaced,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }
}
