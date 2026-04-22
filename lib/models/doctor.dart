class Doctor {
  String id;
  String name;
  String email;
  String specialization;
  double salary;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.specialization,
    required this.salary,
  });

  void displayInfo() {
    print("=== Thông tin Bác sĩ ===");
    print("ID: $id");
    print("Tên: $name");
    print("Email: $email");
    print("Chuyên khoa: $specialization");
    print("Lương: \$$salary");
  }

  void updateSalary(double newSalary) {
    if (newSalary < 0) {
      print("Lương không hợp lệ (âm)");
      return;
    }
    salary = newSalary;
    print("Cập nhật lương thành công: \$$salary");
  }

  bool canWork() {
    return salary > 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'specialization': specialization,
      'salary': salary,
    };
  }
}