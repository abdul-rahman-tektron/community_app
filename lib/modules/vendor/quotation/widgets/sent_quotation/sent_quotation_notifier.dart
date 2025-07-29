import 'package:community_app/core/base/base_notifier.dart';

class SentQuotationNotifier extends BaseChangeNotifier {
  List<QuotationCardModel> quotations = [
    QuotationCardModel(
      customerName: "Fatima Khan",
      sentDate: DateTime.now().subtract(Duration(days: 1)),
      serviceName: "Painting",
      price: 150.0,
      status: QuotationStatus.awaiting,
    ),
    QuotationCardModel(
      customerName: "Ahmed Al Mazroui",
      sentDate: DateTime.now().subtract(Duration(days: 3)),
      serviceName: "AC Maintenance",
      price: 300.0,
      status: QuotationStatus.awaiting,
    ),
    QuotationCardModel(
      customerName: "Sara Al Nuaimi",
      sentDate: DateTime.now().subtract(Duration(days: 5)),
      serviceName: "Plumbing",
      price: 120.0,
      status: QuotationStatus.rejected,
    ),
  ];
}

enum QuotationStatus { awaiting, rejected }

class QuotationCardModel {
  final String customerName;
  final DateTime sentDate;
  final String serviceName;
  final double price;
  final QuotationStatus status;

  QuotationCardModel({
    required this.customerName,
    required this.sentDate,
    required this.serviceName,
    required this.price,
    required this.status,
  });
}