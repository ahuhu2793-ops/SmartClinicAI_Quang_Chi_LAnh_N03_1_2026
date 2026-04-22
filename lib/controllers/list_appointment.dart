import '../models/appointment.dart';

class ListAppointment {
  final List<Appointment> _appointments = [];

  bool _isSameTime(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute;
  }

  // create
  bool createAppointment(Appointment appointment) {
    if (_appointments.any((a) => a.id == appointment.id)) {
      print("ID [${appointment.id}] đã tồn tại.");
      return false;
    }

    if (appointment.appointmentDate.isBefore(DateTime.now())) {
      print("Không thể đặt lịch trong quá khứ.");
      return false;
    }

    bool isDuplicate = _appointments.any((a) =>
        a.doctorId == appointment.doctorId &&
        _isSameTime(a.appointmentDate, appointment.appointmentDate));

    if (isDuplicate) {
      print("Bác sĩ đã có lịch tại thời điểm này.");
      return false;
    }

    _appointments.add(appointment);
    print("Thêm lịch hẹn thành công!");
    return true;
  }

  //read
  List<Appointment> getAllAppointments() {
    return List.unmodifiable(_appointments);
  }

  Appointment? getById(String id) {
    int index = _appointments.indexWhere((a) => a.id == id);
    return index != -1 ? _appointments[index] : null;
  }

  //update
  bool updateAppointment(
    String id, {
    DateTime? newDate,
    String? newReason,
    String? newStatus,
    String? newNote,
  }) {
    var appt = getById(id);
    if (appt == null) {
      print("Không tìm thấy lịch hẹn có ID [$id].");
      return false;
    }

    if (newDate != null) {
      if (newDate.isBefore(DateTime.now())) {
        print("Ngày cập nhật không hợp lệ (nằm trong quá khứ).");
        return false;
      }

      bool isDuplicate = _appointments.any((a) =>
          a.id != id && a.doctorId == appt.doctorId && _isSameTime(a.appointmentDate, newDate));

      if (isDuplicate) {
        print("Cập nhật thất bại. Bác sĩ đã có lịch tại thời điểm mới.");
        return false;
      }
   
      appt.appointmentDate = newDate;
    }

    if (newReason != null) appt.reason = newReason;
    if (newStatus != null) appt.status = newStatus;
    if (newNote != null) appt.note = newNote;

    print("Cập nhật lịch hẹn [$id] thành công");
    return true;
  }

  //delete
  bool deleteAppointment(String id) {
    int initialLength = _appointments.length;
    _appointments.removeWhere((a) => a.id == id);

    if (_appointments.length < initialLength) {
      print("Xóa lịch hẹn [$id] thành công!");
      return true;
    } else {
      print("Không tìm thấy lịch hẹn [$id] để xóa.");
      return false;
    }
    }

  void displayAll() {
    if (_appointments.isEmpty) {
      print("Danh sách lịch hẹn rỗng.");
      return;
    }

    print("DANH SÁCH LỊCH HẸN (${_appointments.length}) ===");
    for (var a in _appointments) {
      a.displayInfo();
    }
  }
}