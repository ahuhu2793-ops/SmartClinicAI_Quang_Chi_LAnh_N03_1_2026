import '../models/patient.dart';

abstract class BaseManager<T> {
  final List<T> items = [];

  bool addItem(
    T item,
    bool Function(T existing) isDuplicate,
  ) {
    if (items.any(isDuplicate)) {
      return false;
    }

    items.add(item);

    return true;
  }

  List<T> getAllItems() {
    return List.unmodifiable(items);
  }

  T? getItem(
    bool Function(T item) condition,
  ) {
    try {
      return items.firstWhere(condition);
    } catch (e) {
      return null;
    }
  }

  bool deleteItem(
    bool Function(T item) condition,
  ) {
    int initialLength = items.length;

    items.removeWhere(condition);

    return items.length < initialLength;
  }
}

class ListPatient extends BaseManager<Patient> {

  bool addPatient(Patient patient) {

    bool success = addItem(
      patient,
      (p) => p.id == patient.id,
    );

    if (success) {
      print("Thêm bệnh nhân thành công!");
    } else {
      print("Bệnh nhân ID [${patient.id}] đã tồn tại.");
    }

    return success;
  }

  List<Patient> getAllPatients() {
    return getAllItems();
  }

  Patient? getById(String id) {

    return getItem(
      (p) => p.id == id,
    );
  }

  bool updatePatient(
    String id, {
    String? newName,
    String? newPhone,
    String? newEmail,
  }) {

    Patient? patient = getById(id);

    if (patient == null) {
      print("Không tìm thấy bệnh nhân ID [$id].");
      return false;
    }

    if (newName != null) {
      patient.name = newName;
    }

    if (newPhone != null) {
      patient.phone = newPhone;
    }

    if (newEmail != null) {
      patient.email = newEmail;
    }

    print("Cập nhật bệnh nhân [$id] thành công.");

    return true;
  }

  bool deletePatient(String id) {

    bool success = deleteItem(
      (p) => p.id == id,
    );

    if (success) {
      print("Xóa bệnh nhân [$id] thành công!");
    } else {
      print("Không tìm thấy bệnh nhân [$id].");
    }

    return success;
  }
}
