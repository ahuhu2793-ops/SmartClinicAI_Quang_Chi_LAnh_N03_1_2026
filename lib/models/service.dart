class Service {
  final String id;
  String serviceCode;
  String name;
  double price;
  String? description;
  int? duration; // in minutes
  String status; // 'active' | 'suspended' | 'inactive'
  DateTime createdAt;
  DateTime updatedAt;

  Service({
    required this.id,
    required this.serviceCode,
    required this.name,
    required this.price,
    this.description,
    this.duration,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == 'active';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceCode': serviceCode,
      'name': name,
      'price': price,
      'description': description ?? '',
      'duration': duration ?? 0,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    final status = map['status'] ??
        ((map['isActive'] ?? true) ? 'active' : 'inactive');
    return Service(
      id: map['id'],
      serviceCode: map['serviceCode'] ?? '',
      name: map['name'],
      price: map['price'].toDouble(),
      description: map['description'],
      duration: map['duration'],
      status: status,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Service copyWith({
    String? id,
    String? serviceCode,
    String? name,
    double? price,
    String? description,
    int? duration,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Service(
      id: id ?? this.id,
      serviceCode: serviceCode ?? this.serviceCode,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'active':
        return 'Đang hoạt động';
      case 'suspended':
        return 'Tạm dừng';
      case 'inactive':
        return 'Ngừng hoạt động';
      default:
        return status;
    }
  }
}
