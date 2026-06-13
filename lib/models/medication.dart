class Medication {
  final String id;
  String name;
  String unit;
  int quantity;
  double importPrice;
  double sellingPrice;
  DateTime? expirationDate;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Medication({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.importPrice,
    required this.sellingPrice,
    this.expirationDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'quantity': quantity,
      'importPrice': importPrice,
      'sellingPrice': sellingPrice,
      'expirationDate': expirationDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      quantity: map['quantity'],
      importPrice: map['importPrice'].toDouble(),
      sellingPrice: map['sellingPrice'].toDouble(),
      expirationDate: map['expirationDate'] != null ? DateTime.parse(map['expirationDate']) : null,
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Medication copyWith({
    String? id,
    String? name,
    String? unit,
    int? quantity,
    double? importPrice,
    double? sellingPrice,
    DateTime? expirationDate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      importPrice: importPrice ?? this.importPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      expirationDate: expirationDate ?? this.expirationDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
