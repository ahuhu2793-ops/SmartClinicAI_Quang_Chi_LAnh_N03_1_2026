class Doctor {
  final String id;
  String doctorCode;
  String name;
  String specialization;
  String email;
  double salary;
  DateTime? dateOfBirth;
  String? workplace;
  String? degree;
  String? phoneNumber;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  Doctor({
    required this.id,
    required this.doctorCode,
    required this.name,
    required this.specialization,
    required this.email,
    required this.salary,
    this.dateOfBirth,
    this.workplace,
    this.degree,
    this.phoneNumber,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorCode': doctorCode,
      'name': name,
      'specialization': specialization,
      'email': email,
      'salary': salary,
      'dateOfBirth': dateOfBirth?.toIso8601String() ?? DateTime(1970, 1, 1).toIso8601String(),
      'workplace': workplace ?? '',
      'degree': degree ?? '',
      'phoneNumber': phoneNumber ?? '',
      'notes': notes ?? '',
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      id: map['id'],
      doctorCode: map['doctorCode'] ?? '',
      name: map['name'],
      specialization: map['specialization'],
      email: map['email'],
      salary: (map['salary'] as num).toDouble(),
      dateOfBirth: map['dateOfBirth'] != null
          ? DateTime.parse(map['dateOfBirth'])
          : null,
      workplace: map['workplace'],
      degree: map['degree'],
      phoneNumber: map['phoneNumber'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Doctor copyWith({
    String? id,
    String? doctorCode,
    String? name,
    String? specialization,
    String? email,
    double? salary,
    DateTime? dateOfBirth,
    String? workplace,
    String? degree,
    String? phoneNumber,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Doctor(
      id: id ?? this.id,
      doctorCode: doctorCode ?? this.doctorCode,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      email: email ?? this.email,
      salary: salary ?? this.salary,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      workplace: workplace ?? this.workplace,
      degree: degree ?? this.degree,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
