import 'appointment.dart';

class Patient {
  String id;
  String name;
  String phone;
  String email;
  DateTime dateOfBirth;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.dateOfBirth,
  });

  void displayInfo() {
    print("=== Thông tin Bệnh nhân ===");
    print("ID: $id");
    print("Tên: $name");
    print("Tuổi: ${getAge()}");
    print("Phone: $phone");
    print("Email: $email");
  }

  bool updateContact({String? newPhone, String? newEmail}) {
    if (newPhone != null && newPhone.isEmpty) {
      print("Số điện thoại không hợp lệ.");
      return false;
    }
    if (newEmail != null && !newEmail.contains('@')) {
      print("Email không hợp lệ.");
      return false;
    }
    if (newPhone != null) phone = newPhone;
    if (newEmail != null) email = newEmail;
    print("Cập nhật thông tin liên hệ thành công.");
    return true;
  }

  bool isAdult() {
    return getAge() >= 18;
  }

  int getAge() {
    DateTime today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    // Kiểm tra xem đã qua sinh nhật trong năm nay chưa
    if (today.month < dateOfBirth.month || 
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  // Gửi email mô phỏng cho bệnh nhân về lịch hẹn
  void mail(Appointment appointment) {
    if (appointment.patientId != id) {
      print("Cảnh báo: appointment.patientId khác với patient.id.");
    }

    print("-- Gửi email tới: $email --");
    final subject = "Thông báo lịch hẹn (#${appointment.id})";
    final buffer = StringBuffer();
    buffer.writeln("Chào $name,");
    buffer.writeln("");
    buffer.writeln("Bạn có lịch hẹn với bác sĩ ${appointment.doctorId} vào ${appointment.appointmentDate}.");
    buffer.writeln("Lý do: ${appointment.reason}");
    if (appointment.note.isNotEmpty) buffer.writeln("Ghi chú: ${appointment.note}");
    buffer.writeln("");
    buffer.writeln("Trạng thái: ${appointment.status}");
    buffer.writeln("");
    buffer.writeln("Trân trọng,\nPhòng khám");

    print("Subject: $subject");
    print("Body:\n${buffer.toString()}");
  }
}