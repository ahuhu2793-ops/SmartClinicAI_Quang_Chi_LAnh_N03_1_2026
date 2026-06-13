class Patient {
  final String id;
  String name;
  String phoneNumber;
  DateTime? dateOfBirth;
  String? email;
  String? gender;
  String? address;
  String? medicalHistory;
  String? notes;
  String? status; // 'active', 'completed', 'cancelled'
  DateTime createdAt;
  DateTime updatedAt;

  Patient({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.address,
    this.medicalHistory,
    this.notes,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'address': address,
      'medicalHistory': medicalHistory,
      'notes': notes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'] ?? map['phone'] ?? '',
      email: map['email'],
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      gender: map['gender'],
      address: map['address'],
      medicalHistory: map['medicalHistory'],
      notes: map['notes'],
      status: map['status'] ?? 'active',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Patient copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? medicalHistory,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
