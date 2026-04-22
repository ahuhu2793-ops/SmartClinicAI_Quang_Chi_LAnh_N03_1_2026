import '../models/doctor.dart';

class ListDoctor {
  List<Doctor> doctors = [];

  // CREATE
  bool addDoctor(Doctor doctor) {
    if (doctors.any((doc) => doc.id == doctor.id)) {
      print("Bác sĩ ID [${doctor.id}] đã tồn tại.");
      return false;
    }
    doctors.add(doctor);
    print("Thêm bác sĩ thành công!");
    return true;
  }

  // READ
  List<Doctor> getAllDoctors() {
    return List.unmodifiable(doctors);
  }

  Doctor? getById(String id) {
    try {
      return doctors.firstWhere((doc) => doc.id == id);
    } catch (e) {
      return null;
    }
  }

  // UPDATE
  bool updateDoctor(String id, {String? newName, String? newEmail, String? newSpecialization, double? newSalary}) {
    Doctor? doc = getById(id);
    if (doc == null) {
      print("Không tìm thấy bác sĩ ID [$id].");
      return false;
    }
    if (newName != null) doc.name = newName;
    if (newEmail != null) doc.email = newEmail;
    if (newSpecialization != null) doc.specialization = newSpecialization;
    if (newSalary != null) doc.updateSalary(newSalary);
    print("Cập nhật bác sĩ [$id] thành công.");
    return true;
  }

  // DELETE
  bool deleteDoctor(String id) {
    int initialLength = doctors.length;
    doctors.removeWhere((doc) => doc.id == id);
    if (doctors.length < initialLength) {
      print("Xóa bác sĩ [$id] thành công!");
      return true;
    } else {
      print("Không tìm thấy bác sĩ [$id].");
      return false;
    }
  }
}