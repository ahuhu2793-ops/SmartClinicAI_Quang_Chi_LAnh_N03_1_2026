import 'dart:convert';

class InvoiceItem {
  String name;
  double price;
  int quantity;

  InvoiceItem({
    required this.name,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'quantity': quantity,
      };

  factory InvoiceItem.fromMap(Map<String, dynamic> map) => InvoiceItem(
        name: map['name'],
        price: (map['price'] as num).toDouble(),
        quantity: map['quantity'] ?? 1,
      );
}

class Invoice {
  final String id;
  String invoiceCode;
  String patientId;
  String patientName;
  String? medicalRecordId;
  String? medicalRecordCode;
  List<InvoiceItem> items;
  double totalAmount;
  String paymentMethod; // 'cash' | 'transfer' | 'card'
  String status; // 'paid' | 'unpaid'
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Invoice({
    required this.id,
    required this.invoiceCode,
    required this.patientId,
    required this.patientName,
    this.medicalRecordId,
    this.medicalRecordCode,
    required this.items,
    required this.totalAmount,
    this.paymentMethod = 'cash',
    this.status = 'unpaid',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceCode': invoiceCode,
      'patientId': patientId,
      'patientName': patientName,
      'medicalRecordId': medicalRecordId,
      'medicalRecordCode': medicalRecordCode,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    var itemsData = map['items'];
    List<dynamic> itemsList = [];
    if (itemsData is String) {
      itemsList = jsonDecode(itemsData) as List<dynamic>;
    } else if (itemsData is List) {
      itemsList = itemsData;
    }
    return Invoice(
      id: map['id'],
      invoiceCode: map['invoiceCode'],
      patientId: map['patientId'],
      patientName: map['patientName'],
      medicalRecordId: map['medicalRecordId'],
      medicalRecordCode: map['medicalRecordCode'],
      items: itemsList
          .map((e) => InvoiceItem.fromMap(e as Map<String, dynamic>))
          .toList(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] ?? 'cash',
      status: map['status'] ?? 'unpaid',
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Invoice copyWith({
    String? id,
    String? invoiceCode,
    String? patientId,
    String? patientName,
    String? medicalRecordId,
    String? medicalRecordCode,
    List<InvoiceItem>? items,
    double? totalAmount,
    String? paymentMethod,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Invoice(
      id: id ?? this.id,
      invoiceCode: invoiceCode ?? this.invoiceCode,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      medicalRecordId: medicalRecordId ?? this.medicalRecordId,
      medicalRecordCode: medicalRecordCode ?? this.medicalRecordCode,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPaid => status == 'paid';

  String get statusDisplayName => status == 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán';

  String get paymentMethodDisplayName {
    switch (paymentMethod) {
      case 'cash':
        return 'Tiền mặt';
      case 'transfer':
        return 'Chuyển khoản';
      case 'card':
        return 'Thẻ';
      default:
        return paymentMethod;
    }
  }
}
