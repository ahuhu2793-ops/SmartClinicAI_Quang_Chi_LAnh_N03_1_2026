class Appointment {
  final String id;
  String appointmentCode;
  String patientId;
  String source;
  String patientName;
  String? phone;
  String? doctorId;
  String? doctorName;
  String? serviceId;
  String? serviceName;
  DateTime appointmentDate;
  String appointmentTime;
  String? notes;
  String status; // 'pending', 'confirmed', 'in_progress', 'completed', 'cancelled'
  // registrationSource removed; use `source` instead
  DateTime createdAt;
  DateTime updatedAt;
  bool confirmed;

  Appointment({
    required this.id,
    required this.appointmentCode,
    required this.patientId,
    required this.patientName,
    this.phone,
    this.doctorId,
    this.doctorName,
    this.serviceId,
    this.serviceName,
    required this.appointmentDate,
    required this.appointmentTime,
    this.notes,
    this.status = 'pending',
    this.source = 'direct',
    this.confirmed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appointmentCode': appointmentCode,
      'patientId': patientId,
      'patientName': patientName,
      'phone': phone,
      'source': source,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': appointmentTime,
      'notes': notes,
      'status': status,
      'confirmed': confirmed,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      appointmentCode: map['appointmentCode'] ?? '',
      patientId: map['patientId'],
      patientName: map['patientName'],
      phone: map['phone'],
      source: map['source'] ?? map['registrationSource'] ?? 'direct',
      doctorId: map['doctorId'],
      doctorName: map['doctorName'],
      serviceId: map['serviceId'],
      serviceName: map['serviceName'],
      appointmentDate: DateTime.parse(map['appointmentDate']),
      appointmentTime: map['appointmentTime'],
      notes: map['notes'],
      status: map['status'] ?? 'pending',
      confirmed: map['confirmed'] is int ? map['confirmed'] == 1 : (map['confirmed'] ?? false),
      
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Appointment copyWith({
    String? id,
    String? appointmentCode,
    String? patientId,
    String? patientName,
    String? phone,
    String? source,
    String? doctorId,
    String? doctorName,
    String? serviceId,
    String? serviceName,
    DateTime? appointmentDate,
    String? appointmentTime,
    String? notes,
    String? status,
    bool? confirmed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      appointmentCode: appointmentCode ?? this.appointmentCode,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      phone: phone ?? this.phone,
      source: source ?? this.source,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      confirmed: confirmed ?? this.confirmed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'pending':
        return 'Chờ xác nhận';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'scheduled':
        return 'Đã đặt';
      case 'in_progress':
        return 'Đang khám';
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }

  String get sourceDisplayName {
    switch (source) {
      case 'admin':
        return 'Quản trị viên';
      case 'receptionist':
        return 'Lễ tân';
      case 'doctor':
        return 'Bác sĩ';
      case 'online':
        return 'Online';
      case 'direct':
        return 'Trực tiếp';
      case 'phone':
        return 'Điện thoại';
      case 'web':
        return 'Website';
      default:
        return source;
    }
  }
}
