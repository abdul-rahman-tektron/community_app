import 'package:community_app/core/base/base_notifier.dart';
import 'package:community_app/core/model/quotation/quotation_model.dart';

class QuotationListNotifier extends BaseChangeNotifier {
  final List<int> _selected = [];

  final List<QuotationModel> quotationList = [
    QuotationModel(
      vendorId: 'VND101',
      vendorName: 'Farnek LLC',
      quotationId: 'QT202307-A',
      items: [
        QuotationItem(quantity: 2, name: 'AC Filter', price: 30),
        QuotationItem(quantity: 1, name: 'Coolant', price: 40),
      ],
      serviceCharge: 50,
      vat: 12,
      siteVisitRequired: true,
      completionTime: '2 Days',
      availabilityDate: '12 Jul',
      availabilityTime: '10:00 AM',
    ),
    QuotationModel(
      vendorId: 'VND102',
      vendorName: "IMDAAD LLC",
      quotationId: 'QT202307-B',
      items: [
        QuotationItem(quantity: 1, name: 'Compressor Oil', price: 60),
        QuotationItem(quantity: 3, name: 'Fan Belt', price: 20),
      ],
      serviceCharge: 60,
      vat: 15,
      siteVisitRequired: false,
      completionTime: '1 Day',
      availabilityDate: '13 Jul',
      availabilityTime: '2:00 PM',
    ),
    QuotationModel(
      vendorId: 'VND103',
      vendorName: "BKA Facilities Management",
      quotationId: 'QT202307-C',
      items: [
        QuotationItem(quantity: 4, name: 'Thermostat', price: 25),
      ],
      serviceCharge: 70,
      vat: 10,
      siteVisitRequired: true,
      completionTime: '3 Days',
      availabilityDate: '14 Jul',
      availabilityTime: '11:30 AM',
    ),
    QuotationModel(
      vendorId: 'VND104',
      vendorName: "Wasl Properties LLC",
      quotationId: 'QT202307-D',
      items: [
        QuotationItem(quantity: 2, name: 'Air Filter', price: 35),
        QuotationItem(quantity: 2, name: 'Refrigerant', price: 45),
        QuotationItem(quantity: 1, name: 'Cooler', price: 80),
        QuotationItem(quantity: 4, name: 'Heater', price: 20),
      ],
      serviceCharge: 40,
      vat: 18,
      siteVisitRequired: false,
      completionTime: 'Same Day',
      availabilityDate: '10 Jul',
      availabilityTime: '4:00 PM',
    ),
  ];


  bool isSelected(int index) => _selected.contains(index);

  void toggle(int index) {
    if (_selected.contains(index)) {
      _selected.remove(index);
    } else {
      _selected.add(index);
    }
    notifyListeners();
  }

  List<int> get selectedIndexes => _selected;
}
