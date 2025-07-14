class QuotationModel {
  final String vendorId;
  final String vendorName;
  final String quotationId;
  final List<QuotationItem> items;
  final double serviceCharge;
  final double vat;
  final bool siteVisitRequired;
  final String completionTime;
  final String availabilityDate;
  final String availabilityTime;

  QuotationModel({
    required this.vendorId,
    required this.vendorName,
    required this.quotationId,
    required this.items,
    required this.serviceCharge,
    required this.vat,
    required this.siteVisitRequired,
    required this.completionTime,
    required this.availabilityDate,
    required this.availabilityTime,
  });

  double get totalWithoutVat =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice) + serviceCharge;

  double get totalWithVat => totalWithoutVat + vat;
}

class QuotationItem {
  final int quantity;
  final String name;
  final double price;

  QuotationItem({
    required this.quantity,
    required this.name,
    required this.price,
  });

  double get totalPrice => quantity * price;
}
