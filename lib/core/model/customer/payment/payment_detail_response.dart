// payment_detail_response.dart
import 'dart:convert';

PaymentDetailResponse paymentDetailResponseFromJson(String str) =>
    PaymentDetailResponse.fromJson(json.decode(str));

class PaymentDetailResponse {
  String? invoiceNumber;
  DateTime? invoiceDate;
  Party? vendor;
  Company? company;
  Party? customer;
  JobInfo? job;
  List<LineItem>? lineItems;
  Totals? totals;

  PaymentDetailResponse({
    this.invoiceNumber,
    this.invoiceDate,
    this.vendor,
    this.company,
    this.customer,
    this.job,
    this.lineItems,
    this.totals,
  });

  factory PaymentDetailResponse.fromJson(Map<String, dynamic> json) {
    // Support both shapes: wrapped {data:{...}} and direct payload
    final root = (json['data'] is Map<String, dynamic>) ? json['data'] : json;

    return PaymentDetailResponse(
      invoiceNumber: root['invoiceNumber'],
      invoiceDate: root['invoiceDate'] == null ? null : DateTime.tryParse(root['invoiceDate']),
      vendor: root['vendor'] == null ? null : Party.fromJson(root['vendor']),
      company: root['company'] == null ? null : Company.fromJson(root['company']),
      customer: root['customer'] == null ? null : Party.fromJson(root['customer']),
      job: root['job'] == null ? null : JobInfo.fromJson(root['job']),
      lineItems: (root['lineItems'] as List?)
          ?.map((e) => LineItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
          <LineItem>[],
      totals: root['totals'] == null ? null : Totals.fromJson(root['totals']),
    );
  }
}

class Party {
  String? name;
  String? address;
  String? email;
  String? phone;
  String? trn;

  Party({this.name, this.address, this.email, this.phone, this.trn});

  factory Party.fromJson(Map<String, dynamic> json) => Party(
    name: json['name'],
    address: json['address'],
    email: json['email'],
    phone: json['phone'],
    trn: json['trn'],
  );
}

class Company {
  String? name;
  String? logoUrl;
  BankDetails? bankDetails;

  Company({this.name, this.logoUrl, this.bankDetails});

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    name: json['name'],
    logoUrl: json['logoUrl'],
    bankDetails: json['bankDetails'] == null
        ? null
        : BankDetails.fromJson(json['bankDetails']),
  );
}

class BankDetails {
  String? bankName;
  String? accountName;
  String? accountNumber;
  String? iban;

  BankDetails({this.bankName, this.accountName, this.accountNumber, this.iban});

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
    bankName: json['bankName'],
    accountName: json['accountName'],
    accountNumber: json['accountNumber'],
    iban: json['iban'],
  );
}

class JobInfo {
  String? serviceName;
  String? jobRef;
  DateTime? requestedDate;
  DateTime? completedDate;

  JobInfo({this.serviceName, this.jobRef, this.requestedDate, this.completedDate});

  factory JobInfo.fromJson(Map<String, dynamic> json) => JobInfo(
    serviceName: json['serviceName'],
    jobRef: json['jobRef'],
    requestedDate: json['requestedDate'] == null
        ? null
        : DateTime.tryParse(json['requestedDate']),
    completedDate: json['completedDate'] == null
        ? null
        : DateTime.tryParse(json['completedDate']),
  );
}

class LineItem {
  int? srNo;
  String? description;
  num? quantity;
  num? rate;
  num? amount; // pre-VAT amount (server)
  num? vat;    // server value (could be amount or percent based on BE)
  num? total;  // server grand per line

  LineItem({
    this.srNo,
    this.description,
    this.quantity,
    this.rate,
    this.amount,
    this.vat,
    this.total,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
    srNo: json['srNo'],
    description: json['description'],
    quantity: json['quantity'],
    rate: json['rate'],
    amount: json['amount'],
    vat: json['vat'],
    total: json['total'],
  );
}

class Totals {
  num? subTotal;
  num? vatTotal;
  num? grandTotal;
  String? vatInWords;
  String? totalInWords;

  Totals({
    this.subTotal,
    this.vatTotal,
    this.grandTotal,
    this.vatInWords,
    this.totalInWords,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
    subTotal: json['subTotal'],
    vatTotal: json['vatTotal'],
    grandTotal: json['grandTotal'],
    vatInWords: json['vatInWords'],
    totalInWords: json['totalInWords'],
  );
}