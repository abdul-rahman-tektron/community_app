import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/vendor/vendor_quotation/create_job_quotation_request.dart';
import 'package:community_app/core/remote/services/service_repository.dart';
import 'package:community_app/utils/helpers/toast_helper.dart';
import 'package:flutter/material.dart';

class AddQuotationNotifier extends BaseChangeNotifier {
  List<QuotationItem> quotationItems = [QuotationItem()];

  int? jobId;
  int? serviceId;
  int? quotationId;

  final TextEditingController notesController = TextEditingController();

  double get subTotal =>
      quotationItems.fold(0, (sum, item) => sum + item.lineTotal);

  double get vat => subTotal * 0.05;

  double get grandTotal => subTotal + vat;

  Future<void> submitQuotation() async {
    try {
      // Build API request object
      final request = VendorCreateJobQuotationRequest(
        jobId: jobId ?? 0,
        serviceId: serviceId ?? 0,
        vendorId: userData?.customerId ?? 0,
        quotationRequestId: quotationId,
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        quotationDetails: notesController.text,
        quotationAmount: grandTotal.toInt(),
        createdBy: "VendorApp", // Can be dynamic
        status: "Submitted",
        jobQuotationResponseItems: quotationItems.map((item) {
          return JobQuotationResponseItem(
            product: item.productController.text,
            quantity: int.tryParse(item.qtyController.text) ?? 0,
            price: int.tryParse(item.unitPriceController.text) ?? 0,
            totalAmount: (item.lineTotal).toInt(),
          );
        }).toList(),
      );

      // Call API
      await ServiceRepository().apiVendorCreateJobQuotationRequest(request);

      ToastHelper.showSuccess("Quotation submitted successfully!");
    } catch (e) {
      ToastHelper.showError("Failed to submit quotation. Please try again.");
    }
  }

  void addItem() {
    quotationItems.add(QuotationItem());
    notifyListeners();
  }

  void removeItem(int index) {
    quotationItems[index].dispose();
    quotationItems.removeAt(index);
    notifyListeners();
  }

  @override
  void dispose() {
    for (var item in quotationItems) {
      item.dispose();
    }
    notesController.dispose();
    super.dispose();
  }
}


class QuotationItem {
  final TextEditingController productController;
  final TextEditingController qtyController;
  final TextEditingController unitPriceController;

  QuotationItem({
    String? product,
    String? qty,
    String? unitPrice,
  })  : productController = TextEditingController(text: product),
        qtyController = TextEditingController(text: qty),
        unitPriceController = TextEditingController(text: unitPrice);

  double get lineTotal {
    final qty = double.tryParse(qtyController.text) ?? 0;
    final price = double.tryParse(unitPriceController.text) ?? 0;
    return qty * price;
  }

  void dispose() {
    productController.dispose();
    qtyController.dispose();
    unitPriceController.dispose();
  }
}