class Appointment {
  String id;
  String patientId;
  String doctorId;
  DateTime appointmentDate;
  String reason;    
  String status;
  String note; 
  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.reason,
    this.status = "Pending",
    this.note = "",
  });

  void displayInfo() {
    print("=== Thông tin Lịch hẹn ===");
    print("ID: $id");
    print("Bệnh nhân: $patientId");
    print("Bác sĩ: $doctorId");
    print("Ngày: $appointmentDate");
    print("Lý do: $reason");
    print("Trạng thái: $status");
    if (note.isNotEmpty) print("Ghi chú: $note");
  }
  // Xác nhận lịch hẹn
  void confirm() {
    status = "Confirmed";
  }

  // Hoàn thành lịch hẹn
  void complete() {
    status = "Completed";
  }

  // Hủy lịch hẹn
  void cancel() {
    status = "Cancelled";
  }

  // Cập nhật ghi chú
  void updateNote(String newNote) {
    note = newNote;
  }

  // Kiểm tra lịch hẹn đã quá thời gian chưa
  bool isPast() {
    return appointmentDate.isBefore(DateTime.now());
  }
}