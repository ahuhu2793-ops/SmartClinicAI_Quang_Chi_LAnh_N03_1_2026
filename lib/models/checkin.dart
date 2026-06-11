class CheckIn {
  final String id;
  String checkinCode;
  String? patientId;
  String patientName;
  String? appointmentId;
  String doctorId;
  String doctorName;
  DateTime checkinDate;
  String checkinTime;
  String status; // 'waiting' | 'in_progress' | 'done' | 'cancelled'
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;

  CheckIn({
    required this.id,
    required this.checkinCode,
    this.patientId,
    required this.patientName,
    this.appointmentId,
    required this.doctorId,
    required this.doctorName,
    required this.checkinDate,
    required this.checkinTime,
    this.status = 'waiting',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'checkinCode': checkinCode,
      'patientId': patientId,
      'patientName': patientName,
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'checkinDate': checkinDate.toIso8601String(),
      'checkinTime': checkinTime,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      id: map['id'],
      checkinCode: map['checkinCode'] ?? '',
      patientId: map['patientId'],
      patientName: map['patientName'],
      appointmentId: map['appointmentId'],
      doctorId: map['doctorId'],
      doctorName: map['doctorName'],
      checkinDate: DateTime.parse(map['checkinDate']),
      checkinTime: map['checkinTime'],
      status: map['status'] ?? 'waiting',
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  CheckIn copyWith({
    String? id,
    String? checkinCode,
    String? patientId,
    String? patientName,
    String? appointmentId,
    String? doctorId,
    String? doctorName,
    DateTime? checkinDate,
    String? checkinTime,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CheckIn(
      id: id ?? this.id,
      checkinCode: checkinCode ?? this.checkinCode,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      appointmentId: appointmentId ?? this.appointmentId,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      checkinDate: checkinDate ?? this.checkinDate,
      checkinTime: checkinTime ?? this.checkinTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'waiting':
        return 'Chờ khám';
      case 'in_progress':
        return 'Đang khám';
      case 'done':
        return 'Đã xong';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}
