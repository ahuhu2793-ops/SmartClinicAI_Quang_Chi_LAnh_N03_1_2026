class Supply {
  final String id;
  String name;
  String unit;
  int quantity;
  double importPrice;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Supply({
    required this.id,
    required this.name,
    required this.unit,
    required this.quantity,
    required this.importPrice,
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
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Supply.fromMap(Map<String, dynamic> map) {
    return Supply(
      id: map['id'],
      name: map['name'],
      unit: map['unit'],
      quantity: map['quantity'],
      importPrice: map['importPrice'].toDouble(),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Supply copyWith({
    String? id,
    String? name,
    String? unit,
    int? quantity,
    double? importPrice,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Supply(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      importPrice: importPrice ?? this.importPrice,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
