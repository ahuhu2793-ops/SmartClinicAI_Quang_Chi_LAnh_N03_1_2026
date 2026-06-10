class ServicePrice {
  final String id;
  String priceCode;
  double price;
  DateTime effectiveDate;
  DateTime? endDate;
  String status; // 'active' | 'inactive'
  DateTime createdAt;
  DateTime updatedAt;

  ServicePrice({
    required this.id,
    required this.priceCode,
    required this.price,
    required this.effectiveDate,
    this.endDate,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == 'active';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'priceCode': priceCode,
      'price': price,
      'effectiveDate': effectiveDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ServicePrice.fromMap(Map<String, dynamic> map) {
    return ServicePrice(
      id: map['id'],
      priceCode: map['priceCode'] ?? '',
      price: (map['price'] as num).toDouble(),
      effectiveDate: DateTime.parse(map['effectiveDate']),
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      status: map['status'] ?? 'active',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  ServicePrice copyWith({
    String? id,
    String? priceCode,
    double? price,
    DateTime? effectiveDate,
    DateTime? endDate,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServicePrice(
      id: id ?? this.id,
      priceCode: priceCode ?? this.priceCode,
      price: price ?? this.price,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
