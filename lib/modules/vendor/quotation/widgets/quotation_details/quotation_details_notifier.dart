import 'package:community_app/core/base/base_notifier.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/enums.dart' show QuotationStatus;

class QuotationItemModel {
  final String product;
  final int qty;
  final double unitPrice;

  QuotationItemModel({
    required this.product,
    required this.qty,
    required this.unitPrice,
  });

  double get lineTotal => qty * unitPrice;
}

class QuotationDetailsNotifier extends BaseChangeNotifier {
  // Static/fake data for UI preview
  String customerName = "Ahmed Al Mazroui";
  String phone = "05576263567";
  String location = "Jumeirah, Villa 23";
  String serviceName = "Painting";
  String requestedDate = "3 July 2025";
  String notes = "The quotation covers labor and materials for indoor wall painting only. Any additional work will be quoted separately.";

  QuotationStatus status = QuotationStatus.rejected;

  List<QuotationItemModel> quotationItems = [
    QuotationItemModel(product: "Wall Paint", qty: 2, unitPrice: 100.0),
    QuotationItemModel(product: "Ceiling Paint", qty: 1, unitPrice: 120.0),
  ];

  double get subTotal => quotationItems.fold(0, (sum, item) => sum + item.lineTotal);
  double get vat => subTotal * 0.05;
  double get grandTotal => subTotal + vat;

  bool get isRejected => status == QuotationStatus.rejected;

  void resendQuotation() {
    // TODO: Implement resend logic
    print("Resending quotation...");
  }
}
