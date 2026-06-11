class MedicalRecord {
  final String id;
  String recordCode;
  String patientId;
  String patientName;
  String doctorId;
  String doctorName;
  String? checkinId;
  String? symptoms;
  String diagnosis;
  String treatment;
  String? prescription;
  String? notes;
  String status; // 'examining' | 'completed' | 'cancelled'
  DateTime createdAt;
  DateTime updatedAt;

  MedicalRecord({
    required this.id,
    required this.recordCode,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    this.checkinId,
    this.symptoms,
    required this.diagnosis,
    required this.treatment,
    this.prescription,
    this.notes,
    this.status = 'examining',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recordCode': recordCode,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'checkinId': checkinId,
      'symptoms': symptoms,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'prescription': prescription,
      'notes': notes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map) {
    return MedicalRecord(
      id: map['id'],
      recordCode: map['recordCode'],
      patientId: map['patientId'],
      patientName: map['patientName'],
      doctorId: map['doctorId'],
      doctorName: map['doctorName'],
      checkinId: map['checkinId'],
      symptoms: map['symptoms'],
      diagnosis: map['diagnosis'],
      treatment: map['treatment'],
      prescription: map['prescription'],
      notes: map['notes'],
      status: map['status'] ?? 'examining',
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  MedicalRecord copyWith({
    String? id,
    String? recordCode,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? checkinId,
    String? symptoms,
    String? diagnosis,
    String? treatment,
    String? prescription,
    String? notes,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      recordCode: recordCode ?? this.recordCode,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      checkinId: checkinId ?? this.checkinId,
      symptoms: symptoms ?? this.symptoms,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case 'examining':
        return 'Đang khám';
      case 'completed':
        return 'Hoàn tất';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}
