import '../models/patient.dart';

class ListPatient {
  List<Patient> patients = [];

  bool addPatient(Patient patient) {
    if (patients.any((p) => p.id == patient.id)) {
      print("Bệnh nhân ID [${patient.id}] đã tồn tại.");
      return false;
    }
    patients.add(patient);
    print("Thêm bệnh nhân thành công!");
    return true;
  }

  List<Patient> getAllPatients() {
    return List.unmodifiable(patients);
  }

  Patient? getById(String id) {
    try {
      return patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  bool updatePatient(String id, {String? newName, String? newPhone, String? newEmail}) {
    Patient? patient = getById(id);
    if (patient == null) {
      print("Không tìm thấy bệnh nhân ID [$id].");
      return false;
    }
    if (newName != null) patient.name = newName;
    if (newPhone != null) patient.phone = newPhone;
    if (newEmail != null) patient.email = newEmail;
    print("Cập nhật bệnh nhân [$id] thành công.");
    return true;
  }

  bool deletePatient(String id) {
    int initialLength = patients.length;
    patients.removeWhere((p) => p.id == id);
    if (patients.length < initialLength) {
      print("Xóa bệnh nhân [$id] thành công!");
      return true;
    } else {
      print("Không tìm thấy bệnh nhân [$id].");
      return false;
    }
  }
}