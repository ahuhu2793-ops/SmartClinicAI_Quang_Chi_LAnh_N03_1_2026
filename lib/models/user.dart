class User {
  final String id;
  String username;
  String name;
  String email;
  String password;
  String phone;
  String role; // 'admin' | 'receptionist' | 'doctor' | 'patient'
  String status; // 'active' | 'inactive'
  String? patientId; // Link to patient record if user is a patient
  String? doctorId;  // Link to doctor record if user is a doctor
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    this.role = 'patient',
    this.status = 'active',
    this.patientId,
    this.doctorId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'role': role,
      'status': status,
      'patientId': patientId,
      'doctorId': doctorId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'] ?? map['email'] ?? '',
      name: map['name'],
      email: map['email'] ?? '',
      password: map['password'],
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'patient',
      status: map['status'] ?? 'active',
      patientId: map['patientId'],
      doctorId: map['doctorId'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  User copyWith({
    String? id,
    String? username,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? role,
    String? status,
    String? patientId,
    String? doctorId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      status: status ?? this.status,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isAdmin => role == 'admin';
  bool get isReceptionist => role == 'receptionist';
  bool get isDoctor => role == 'doctor';
  bool get isPatient => role == 'patient';
  bool get isActive => status == 'active';

  String get roleDisplayName {
    switch (role) {
      case 'admin':
        return 'Quản trị viên';
      case 'receptionist':
        return 'Lễ tân';
      case 'doctor':
        return 'Bác sĩ';
      case 'patient':
        return 'Bệnh nhân';
      default:
        return role;
    }
  }
}
