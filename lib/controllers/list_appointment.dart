import '../models/appointment.dart';
import 'generic_list.dart';

class ListAppointment {
  final GenericList<Appointment> _store = GenericList<Appointment>(idGetter: (a) => a.id);

  bool _isSameTime(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute;
  }

  bool createAppointment(Appointment appointment) {
    if (appointment.appointmentDate.isBefore(DateTime.now())) {
      print("Không thể đặt lịch trong quá khứ.");
      return false;
    }

    final all = _store.getAll();

    if (all.any((a) => a.id == appointment.id)) {
      print("ID [${appointment.id}] đã tồn tại.");
      return false;
    }

    bool isDuplicate = all.any((a) =>
        a.doctorId == appointment.doctorId && _isSameTime(a.appointmentDate, appointment.appointmentDate));

    if (isDuplicate) {
      print("Bác sĩ đã có lịch tại thời điểm này.");
      return false;
    }

    final ok = _store.add(appointment);
    if (ok) {
      print("Thêm lịch hẹn thành công!");
      return true;
    }
    print("Thêm lịch hẹn thất bại.");
    return false;
  }

  List<Appointment> getAllAppointments() => _store.getAll();

  Appointment? getById(String id) => _store.getById(id);

  bool updateAppointment(
    String id, {
    DateTime? newDate,
    String? newReason,
    String? newStatus,
    String? newNote,
  }) {
    final appt = getById(id);
    if (appt == null) {
      print("Không tìm thấy lịch hẹn có ID [$id].");
      return false;
    }

    final all = _store.getAll();

    if (newDate != null) {
      if (newDate.isBefore(DateTime.now())) {
        print("Ngày cập nhật không hợp lệ (nằm trong quá khứ).");
        return false;
      }

      bool isDuplicate = all.any((a) =>
          a.id != id && a.doctorId == appt.doctorId && _isSameTime(a.appointmentDate, newDate));

      if (isDuplicate) {
        print("Cập nhật thất bại. Bác sĩ đã có lịch tại thời điểm mới.");
        return false;
      }
    }

    final updated = _store.update(id, (a) {
      if (newDate != null) a.appointmentDate = newDate;
      if (newReason != null) a.reason = newReason;
      if (newStatus != null) a.status = newStatus;
      if (newNote != null) a.note = newNote;
    });

    if (!updated) {
      print("Cập nhật thất bại.");
      return false;
    }

    print("Cập nhật lịch hẹn [$id] thành công");
    return true;
  }

  bool deleteAppointment(String id) {
    final ok = _store.delete(id);
    if (ok) {
      print("Xóa lịch hẹn [$id] thành công!");
      return true;
    }
    print("Không tìm thấy lịch hẹn [$id] để xóa.");
    return false;
  }

  void displayAll() {
    final all = _store.getAll();
    if (all.isEmpty) {
      print("Danh sách lịch hẹn rỗng.");
      return;
    }

    print("DANH SÁCH LỊCH HẸN (${all.length}) ===");
    for (var a in all) {
      a.displayInfo();
    }
  }
}