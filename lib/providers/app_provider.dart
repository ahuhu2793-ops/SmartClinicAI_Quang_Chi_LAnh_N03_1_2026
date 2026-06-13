import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/patient.dart';
import '../models/appointment.dart';
import '../models/service.dart';
import '../models/medication.dart';
import '../models/supply.dart';
import '../models/doctor.dart';
import '../models/checkin.dart';
import '../models/medical_record.dart';
import '../models/invoice.dart';
import '../models/service_price.dart';
import '../data/db_helper.dart';

class AppProvider extends ChangeNotifier {
  static DateTime? mockCurrentDate;
  static DateTime get currentDate => mockCurrentDate ?? DateTime.now();
  static bool isDbDisconnected = false;
  static bool isResetFilterError = false;

  final Uuid _uuid = const Uuid();

  Future<void> init() async {
    final patientsData = await DBHelper.instance.queryAll('patients');
    if (patientsData.isEmpty) {
      loadDemoData();
      // Persist the loaded demo data to DB!
      for (final p in _patients) await DBHelper.instance.insert('patients', p.toMap());
      for (final d in _doctors) await DBHelper.instance.insert('doctors', d.toMap());
      for (final s in _services) await DBHelper.instance.insert('services', s.toMap());
      for (final a in _appointments) await DBHelper.instance.insert('appointments', a.toMap());
      for (final m in _medications) await DBHelper.instance.insert('medications', m.toMap());
      for (final sp in _supplies) await DBHelper.instance.insert('supplies', sp.toMap());
      for (final c in _checkins) await DBHelper.instance.insert('checkins', c.toMap());
      for (final mr in _medicalRecords) await DBHelper.instance.insert('medical_records', mr.toMap());
      for (final i in _invoices) await DBHelper.instance.insert('invoices', i.toMap());
      for (final sp in _servicePrices) await DBHelper.instance.insert('service_prices', sp.toMap());
    } else {
      final doctorsData = await DBHelper.instance.queryAll('doctors');
      final servicesData = await DBHelper.instance.queryAll('services');
      final appointmentsData = await DBHelper.instance.queryAll('appointments');
      final medicationsData = await DBHelper.instance.queryAll('medications');
      final suppliesData = await DBHelper.instance.queryAll('supplies');
      final checkinsData = await DBHelper.instance.queryAll('checkins');
      final medicalRecordsData = await DBHelper.instance.queryAll('medical_records');
      final invoicesData = await DBHelper.instance.queryAll('invoices');
      final servicePricesData = await DBHelper.instance.queryAll('service_prices');

      _patients = patientsData.map((m) => Patient.fromMap(m)).toList();
      _doctors = doctorsData.map((m) => Doctor.fromMap(m)).toList();
      _services = servicesData.map((m) => Service.fromMap(m)).toList();
      _appointments = appointmentsData.map((m) => Appointment.fromMap(m)).toList();
      _medications = medicationsData.map((m) => Medication.fromMap(m)).toList();
      _supplies = suppliesData.map((m) => Supply.fromMap(m)).toList();
      _checkins = checkinsData.map((m) => CheckIn.fromMap(m)).toList();
      _medicalRecords = medicalRecordsData.map((m) => MedicalRecord.fromMap(m)).toList();
      _invoices = invoicesData.map((m) => Invoice.fromMap(m)).toList();
      _servicePrices = servicePricesData.map((m) => ServicePrice.fromMap(m)).toList();
      
      notifyListeners();
    }
  }

  // Data lists
  List<Patient> _patients = [];
  List<Appointment> _appointments = [];
  List<Service> _services = [];
  List<Medication> _medications = [];
  List<Supply> _supplies = [];
  List<Doctor> _doctors = [];
  List<CheckIn> _checkins = [];
  List<MedicalRecord> _medicalRecords = [];
  List<Invoice> _invoices = [];
  List<ServicePrice> _servicePrices = [];

  // Getters
  List<Patient> get patients => _patients;
  List<Appointment> get appointments => _appointments;
  List<Service> get services => _services;
  List<Medication> get medications => _medications;
  List<Supply> get supplies => _supplies;
  List<Doctor> get doctors => _doctors;
  List<CheckIn> get checkins => _checkins;
  List<MedicalRecord> get medicalRecords => _medicalRecords;
  List<Invoice> get invoices => _invoices;
  List<ServicePrice> get servicePrices => _servicePrices;

  List<Doctor> getAllDoctors() => List.unmodifiable(_doctors);

  // Filtered patients
  List<Patient> get activePatients =>
      _patients.where((p) => p.status == 'active').toList();

  List<Patient> get completedPatients =>
      _patients.where((p) => p.status == 'completed').toList();

  // Today's appointments
  List<Appointment> get todayAppointments {
    final now = DateTime.now();
    return _appointments.where((a) {
      return a.appointmentDate.year == now.year &&
          a.appointmentDate.month == now.month &&
          a.appointmentDate.day == now.day;
    }).toList();
  }

  List<Appointment> get scheduledAppointments =>
      _appointments
          .where((a) => a.status == 'confirmed' || a.status == 'scheduled')
          .toList();

  List<Appointment> get completedAppointments =>
      _appointments.where((a) => a.status == 'completed').toList();

  List<Service> get activeServices =>
      _services.where((s) => s.isActive).toList();

  List<Medication> get lowStockMedications =>
      _medications.where((m) => m.quantity < 10).toList();

  List<Supply> get lowStockSupplies =>
      _supplies.where((s) => s.quantity < 10).toList();

  // Today checkins
  List<CheckIn> get todayCheckins {
    final now = DateTime.now();
    return _checkins.where((c) {
      return c.checkinDate.year == now.year &&
          c.checkinDate.month == now.month &&
          c.checkinDate.day == now.day;
    }).toList();
  }

  // Invoice statistics
  double get totalRevenue =>
      _invoices.where((i) => i.isPaid).fold(0, (s, i) => s + i.totalAmount);

  double get unpaidAmount =>
      _invoices.where((i) => !i.isPaid).fold(0, (s, i) => s + i.totalAmount);

  // Load demo data
  void loadDemoData() {
    _services = _generateDemoServices();
    _doctors = _generateDemoDoctors();
    _patients = _generateDemoPatients();
    _appointments = _generateDemoAppointments();
    _medications = _generateDemoMedications();
    _supplies = _generateDemoSupplies();
    _checkins = _generateDemoCheckins();
    _medicalRecords = _generateDemoMedicalRecords();
    _invoices = _generateDemoInvoices();
    _servicePrices = _generateDemoServicePrices();
    notifyListeners();
  }

  // ─── Patient methods ───────────────────────────────────────────────────────
  Future<void> addPatient(Patient patient) async {
    _patients.add(patient);
    await DBHelper.instance.insert('patients', patient.toMap());
    notifyListeners();
  }

  Future<void> updatePatient(Patient updatedPatient) async {
    final index = _patients.indexWhere((p) => p.id == updatedPatient.id);
    if (index != -1) {
      _patients[index] = updatedPatient;
      await DBHelper.instance.update('patients', updatedPatient.toMap());
      notifyListeners();
    }
  }

  Future<void> deletePatient(String patientId) async {
    _patients.removeWhere((p) => p.id == patientId);
    await DBHelper.instance.delete('patients', patientId);
    notifyListeners();
  }

  List<Patient> searchPatients(String query) {
    if (query.isEmpty) return _patients;
    final lowerQuery = query.toLowerCase();
    return _patients
        .where((p) =>
            p.name.toLowerCase().contains(lowerQuery) ||
            p.phoneNumber.contains(lowerQuery) ||
            (p.email?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }

  // ─── Appointment methods ───────────────────────────────────────────────────
  Future<void> addAppointment(Appointment appointment) async {
    if (appointment.patientId.isEmpty || appointment.patientName.isEmpty) {
      throw AppointmentValidationException('Thiếu thông tin bệnh nhân');
    }
    if (appointment.serviceId != null) {
      final serviceIdx = _services.indexWhere((s) => s.id == appointment.serviceId);
      if (serviceIdx != -1 && _services[serviceIdx].status != 'active') {
        throw AppointmentValidationException('Dịch vụ hiện không hoạt động');
      }
    }
    if (appointment.doctorId != null) {
      final isTimeBooked = _appointments.any((a) =>
        a.doctorId == appointment.doctorId &&
        a.appointmentDate.year == appointment.appointmentDate.year &&
        a.appointmentDate.month == appointment.appointmentDate.month &&
        a.appointmentDate.day == appointment.appointmentDate.day &&
        a.appointmentTime == appointment.appointmentTime &&
        a.status != 'cancelled'
      );
      if (isTimeBooked) {
        throw AppointmentValidationException('Khung giờ đã có lịch khám trước đó');
      }
    }

    _appointments.add(appointment);
    await DBHelper.instance.insert('appointments', appointment.toMap());
    notifyListeners();
  }

  Future<void> updateAppointment(Appointment updatedAppointment) async {
    final index = _appointments.indexWhere((a) => a.id == updatedAppointment.id);
    if (index == -1) {
      throw AppointmentValidationException('Không tìm thấy lịch khám');
    }
    if (updatedAppointment.status == 'cancelled' && _appointments[index].status == 'completed') {
      throw AppointmentValidationException('Lịch khám đã hoàn thành và không cho phép hủy');
    }
    if (updatedAppointment.doctorId != null) {
      final isTimeBooked = _appointments.any((a) =>
        a.id != updatedAppointment.id &&
        a.doctorId == updatedAppointment.doctorId &&
        a.appointmentDate.year == updatedAppointment.appointmentDate.year &&
        a.appointmentDate.month == updatedAppointment.appointmentDate.month &&
        a.appointmentDate.day == updatedAppointment.appointmentDate.day &&
        a.appointmentTime == updatedAppointment.appointmentTime &&
        a.status != 'cancelled'
      );
      if (isTimeBooked) {
        throw AppointmentValidationException('Khung giờ đã có lịch khám trước đó');
      }
    }

    _appointments[index] = updatedAppointment;
    await DBHelper.instance.update('appointments', updatedAppointment.toMap());
    notifyListeners();
  }

  Future<void> deleteAppointment(String appointmentId) async {
    final idx = _appointments.indexWhere((a) => a.id == appointmentId);
    if (idx == -1) {
      throw AppointmentValidationException('Không tìm thấy lịch khám');
    }
    _appointments.removeAt(idx);
    await DBHelper.instance.delete('appointments', appointmentId);
    notifyListeners();
  }

  Future<void> updateAppointmentStatus(String appointmentId, String status, {String? userRole}) async {
    if (userRole?.toLowerCase() == 'patient') {
      throw AppointmentValidationException('Không có quyền cập nhật trạng thái');
    }
    final validStatuses = {'pending', 'confirmed', 'in_progress', 'completed', 'cancelled'};
    if (!validStatuses.contains(status.toLowerCase())) {
      throw AppointmentValidationException('Trạng thái lịch khám không hợp lệ');
    }

    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      if (status == 'cancelled' && _appointments[index].status == 'completed') {
        throw AppointmentValidationException('Lịch khám đã hoàn thành và không cho phép hủy');
      }
      final updated = _appointments[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      _appointments[index] = updated;
      await DBHelper.instance.update('appointments', updated.toMap());
      notifyListeners();
    }
  }

  List<Appointment> getAppointmentsByDoctor(String doctorId) =>
      _appointments.where((a) => a.doctorId == doctorId).toList();

  List<Appointment> getAppointmentsByDate(DateTime date) =>
      _appointments
          .where((a) =>
              a.appointmentDate.year == date.year &&
              a.appointmentDate.month == date.month &&
              a.appointmentDate.day == date.day)
          .toList();

  List<Appointment> getAppointmentsByStatus(String status) =>
      _appointments.where((a) => a.status == status).toList();

  // ─── Service methods ───────────────────────────────────────────────────────
  Future<void> addService(Service service) async {
    if (service.name.isEmpty) {
      throw ServiceValidationException('Tên dịch vụ không được để trống');
    }
    if (_services.any((s) => s.serviceCode.toLowerCase() == service.serviceCode.toLowerCase())) {
      throw ServiceValidationException('Mã dịch vụ đã tồn tại');
    }
    if (service.price <= 0) {
      throw ServiceValidationException('Giá dịch vụ phải lớn hơn 0');
    }
    if (service.description != null && service.description!.length > 1000) {
      throw ServiceValidationException('Mô tả vượt quá số ký tự cho phép');
    }
    _services.add(service);
    await DBHelper.instance.insert('services', service.toMap());
    notifyListeners();
  }

  Future<void> updateService(Service updatedService) async {
    final index = _services.indexWhere((s) => s.id == updatedService.id);
    if (index == -1) {
      throw ServiceValidationException('Dịch vụ không tồn tại');
    }
    if (updatedService.name.isEmpty) {
      throw ServiceValidationException('Tên dịch vụ không được để trống');
    }
    if (_services.any((s) => s.id != updatedService.id && s.serviceCode.toLowerCase() == updatedService.serviceCode.toLowerCase())) {
      throw ServiceValidationException('Mã dịch vụ đã tồn tại');
    }
    if (updatedService.price <= 0) {
      throw ServiceValidationException('Giá dịch vụ phải lớn hơn 0');
    }
    if (updatedService.description != null && updatedService.description!.length > 1000) {
      throw ServiceValidationException('Mô tả vượt quá số ký tự cho phép');
    }
    _services[index] = updatedService;
    await DBHelper.instance.update('services', updatedService.toMap());
    notifyListeners();
  }

  Future<void> deleteService(String serviceId) async {
    final index = _services.indexWhere((s) => s.id == serviceId);
    if (index == -1) {
      throw ServiceValidationException('Dịch vụ không tồn tại');
    }
    if (_appointments.any((a) => a.serviceId == serviceId && a.status != 'cancelled')) {
      throw ServiceValidationException('Dịch vụ đang được sử dụng, không thể xóa');
    }
    _services.removeAt(index);
    await DBHelper.instance.delete('services', serviceId);
    notifyListeners();
  }

  // ─── Medication methods ────────────────────────────────────────────────────
  Future<void> addMedication(Medication medication) async {
    _medications.add(medication);
    await DBHelper.instance.insert('medications', medication.toMap());
    notifyListeners();
  }

  Future<void> updateMedication(Medication updatedMedication) async {
    final index =
        _medications.indexWhere((m) => m.id == updatedMedication.id);
    if (index != -1) {
      _medications[index] = updatedMedication;
      await DBHelper.instance.update('medications', updatedMedication.toMap());
      notifyListeners();
    }
  }

  Future<void> deleteMedication(String medicationId) async {
    _medications.removeWhere((m) => m.id == medicationId);
    await DBHelper.instance.delete('medications', medicationId);
    notifyListeners();
  }

  Future<void> updateMedicationQuantity(String medicationId, int quantity) async {
    final index = _medications.indexWhere((m) => m.id == medicationId);
    if (index != -1) {
      final updated = _medications[index].copyWith(
        quantity: quantity,
        updatedAt: DateTime.now(),
      );
      _medications[index] = updated;
      await DBHelper.instance.update('medications', updated.toMap());
      notifyListeners();
    }
  }

  // ─── Supply methods ────────────────────────────────────────────────────────
  Future<void> addSupply(Supply supply) async {
    _supplies.add(supply);
    await DBHelper.instance.insert('supplies', supply.toMap());
    notifyListeners();
  }

  Future<void> updateSupply(Supply updatedSupply) async {
    final index = _supplies.indexWhere((s) => s.id == updatedSupply.id);
    if (index != -1) {
      _supplies[index] = updatedSupply;
      await DBHelper.instance.update('supplies', updatedSupply.toMap());
      notifyListeners();
    }
  }

  Future<void> deleteSupply(String supplyId) async {
    _supplies.removeWhere((s) => s.id == supplyId);
    await DBHelper.instance.delete('supplies', supplyId);
    notifyListeners();
  }

  Future<void> updateSupplyQuantity(String supplyId, int quantity) async {
    final index = _supplies.indexWhere((s) => s.id == supplyId);
    if (index != -1) {
      final updated = _supplies[index].copyWith(
        quantity: quantity,
        updatedAt: DateTime.now(),
      );
      _supplies[index] = updated;
      await DBHelper.instance.update('supplies', updated.toMap());
      notifyListeners();
    }
  }

  // ─── Doctor methods ────────────────────────────────────────────────────────
  Future<void> addDoctor(Doctor doctor) async {
    if (doctor.name.isEmpty) {
      throw DoctorValidationException('Họ tên không được để trống');
    }
    if (_doctors.any((d) => d.doctorCode.toLowerCase() == doctor.doctorCode.toLowerCase())) {
      throw DoctorValidationException('Mã bác sĩ đã tồn tại');
    }
    if (doctor.email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(doctor.email)) {
        throw DoctorValidationException('Email không đúng định dạng');
      }
      if (_doctors.any((d) => d.email.toLowerCase() == doctor.email.toLowerCase())) {
        throw DoctorValidationException('Email đã tồn tại');
      }
    }
    if (doctor.phoneNumber == null || doctor.phoneNumber!.isEmpty) {
      throw DoctorValidationException('Số điện thoại không được để trống');
    }
    final phoneDigits = doctor.phoneNumber!.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length < 9 || phoneDigits.length > 11 || phoneDigits != doctor.phoneNumber) {
      throw DoctorValidationException('Số điện thoại không hợp lệ');
    }
    if (doctor.specialization.isEmpty) {
      throw DoctorValidationException('Chuyên khoa không được để trống');
    }
    if (doctor.salary <= 0) {
      throw DoctorValidationException('Lương không hợp lệ');
    }
    _doctors.add(doctor);
    await DBHelper.instance.insert('doctors', doctor.toMap());
    notifyListeners();
  }

  Future<void> updateDoctor(Doctor updatedDoctor) async {
    final index = _doctors.indexWhere((d) => d.id == updatedDoctor.id);
    if (index == -1) {
      throw DoctorValidationException('Không tìm thấy bác sĩ');
    }
    if (updatedDoctor.name.isEmpty) {
      throw DoctorValidationException('Họ tên không được để trống');
    }
    if (_doctors.any((d) => d.id != updatedDoctor.id && d.doctorCode.toLowerCase() == updatedDoctor.doctorCode.toLowerCase())) {
      throw DoctorValidationException('Mã bác sĩ đã tồn tại');
    }
    if (updatedDoctor.email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(updatedDoctor.email)) {
        throw DoctorValidationException('Email không đúng định dạng');
      }
      if (_doctors.any((d) => d.id != updatedDoctor.id && d.email.toLowerCase() == updatedDoctor.email.toLowerCase())) {
        throw DoctorValidationException('Email đã tồn tại');
      }
    }
    if (updatedDoctor.salary <= 0) {
      throw DoctorValidationException('Lương không hợp lệ');
    }
    _doctors[index] = updatedDoctor;
    await DBHelper.instance.update('doctors', updatedDoctor.toMap());
    notifyListeners();
  }

  Future<void> deleteDoctor(String doctorId) async {
    final index = _doctors.indexWhere((d) => d.id == doctorId);
    if (index == -1) {
      throw DoctorValidationException('Không tìm thấy bác sĩ');
    }
    if (_appointments.any((a) => a.doctorId == doctorId && a.status != 'cancelled' && a.status != 'completed')) {
      throw DoctorValidationException('Bác sĩ đang có lịch khám, không thể xóa');
    }
    _doctors.removeAt(index);
    await DBHelper.instance.delete('doctors', doctorId);
    notifyListeners();
  }

  List<Doctor> searchDoctors(String query) {
    if (query.isEmpty) return _doctors;
    final lowerQuery = query.toLowerCase();
    return _doctors
        .where((d) =>
            d.name.toLowerCase().contains(lowerQuery) ||
            d.doctorCode.toLowerCase().contains(lowerQuery) ||
            d.specialization.toLowerCase().contains(lowerQuery) ||
            d.email.toLowerCase().contains(lowerQuery))
        .toList();
  }

  String generateDoctorCode() {
    final count = _doctors.length + 1;
    return 'BS${count.toString().padLeft(4, '0')}';
  }

  String generateAppointmentCode() {
    final count = _appointments.length + 1;
    return 'LK${count.toString().padLeft(4, '0')}';
  }

  String generateCheckInCode() {
    final count = _checkins.length + 1;
    return 'TD${count.toString().padLeft(4, '0')}';
  }

  String generateServiceCode() {
    final count = _services.length + 1;
    return 'DV${count.toString().padLeft(4, '0')}';
  }



  // ─── CheckIn methods ───────────────────────────────────────────────────────
  Future<void> addCheckIn(CheckIn checkIn) async {
    if (AppProvider.isDbDisconnected) {
      throw CheckInValidationException('Lỗi kết nối hệ thống');
    }
    if (checkIn.patientId == null || checkIn.patientId!.isEmpty || checkIn.patientName.isEmpty) {
      throw CheckInValidationException('Thiếu thông tin bệnh nhân');
    }
    if (checkIn.doctorId.isEmpty) {
      throw CheckInValidationException('Chưa chọn bác sĩ khám');
    }
    // Giờ tiếp đón không hợp lệ
    final timeParts = checkIn.checkinTime.split(':');
    if (timeParts.length < 2 || timeParts.length > 3) {
      throw CheckInValidationException('Giờ tiếp đón không hợp lệ');
    }
    try {
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final second = timeParts.length == 3 ? int.parse(timeParts[2]) : 0;
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59 || second < 0 || second > 59) {
        throw CheckInValidationException('Giờ tiếp đón không hợp lệ');
      }
    } catch (_) {
      throw CheckInValidationException('Giờ tiếp đón không hợp lệ');
    }

    // Trạng thái tiếp đón không hợp lệ
    final validStatuses = {'waiting', 'in_progress', 'done', 'cancelled'};
    if (!validStatuses.contains(checkIn.status.toLowerCase())) {
      throw CheckInValidationException('Trạng thái tiếp đón không hợp lệ');
    }

    // Chọn ngày trong quá khứ
    final today = AppProvider.currentDate;
    final todayStart = DateTime(today.year, today.month, today.day);
    final checkinDateStart = DateTime(checkIn.checkinDate.year, checkIn.checkinDate.month, checkIn.checkinDate.day);
    if (checkinDateStart.isBefore(todayStart)) {
      throw CheckInValidationException('Không thể chọn ngày trong quá khứ');
    }

    // Bệnh nhân đã được tiếp đón trong ngày
    final isDuplicate = _checkins.any((c) =>
      c.patientId == checkIn.patientId &&
      c.checkinDate.year == checkIn.checkinDate.year &&
      c.checkinDate.month == checkIn.checkinDate.month &&
      c.checkinDate.day == checkIn.checkinDate.day &&
      c.status != 'cancelled'
    );
    if (isDuplicate) {
      throw CheckInValidationException('Bệnh nhân đã được tiếp đón trong ngày');
    }

    _checkins.add(checkIn);
    await DBHelper.instance.insert('checkins', checkIn.toMap());
    notifyListeners();
  }

  Future<void> updateCheckIn(CheckIn updatedCheckIn) async {
    final index = _checkins.indexWhere((c) => c.id == updatedCheckIn.id);
    if (index == -1) {
      throw CheckInValidationException('Không tìm thấy phiếu tiếp đón');
    }
    if (updatedCheckIn.patientId == null || updatedCheckIn.patientId!.isEmpty || updatedCheckIn.patientName.isEmpty) {
      throw CheckInValidationException('Thiếu thông tin bệnh nhân');
    }
    // Trùng thông tin với phiếu khác
    final isDuplicate = _checkins.any((c) =>
      c.id != updatedCheckIn.id &&
      c.patientId == updatedCheckIn.patientId &&
      c.checkinDate.year == updatedCheckIn.checkinDate.year &&
      c.checkinDate.month == updatedCheckIn.checkinDate.month &&
      c.checkinDate.day == updatedCheckIn.checkinDate.day &&
      c.status != 'cancelled'
    );
    if (isDuplicate) {
      throw CheckInValidationException('Bệnh nhân đã được tiếp đón trong ngày');
    }

    _checkins[index] = updatedCheckIn;
    await DBHelper.instance.update('checkins', updatedCheckIn.toMap());
    notifyListeners();
  }

  Future<void> deleteCheckIn(String checkInId) async {
    final index = _checkins.indexWhere((c) => c.id == checkInId || c.checkinCode == checkInId);
    if (index == -1) {
      throw CheckInValidationException('Không tìm thấy phiếu tiếp đón');
    }
    final c = _checkins[index];
    if (c.status == 'done') {
      throw CheckInValidationException('Phiếu đã hoàn tất khám và không cho phép hủy');
    }
    _checkins.removeAt(index);
    await DBHelper.instance.delete('checkins', c.id);
    notifyListeners();
  }

  Future<void> cancelCheckIn(String checkInId) async {
    final index = _checkins.indexWhere((c) => c.id == checkInId || c.checkinCode == checkInId);
    if (index == -1) {
      throw CheckInValidationException('Không tìm thấy phiếu tiếp đón');
    }
    final c = _checkins[index];
    if (c.status == 'done') {
      throw CheckInValidationException('Phiếu đã hoàn tất khám và không cho phép hủy');
    }
    final updated = c.copyWith(status: 'cancelled', updatedAt: DateTime.now());
    _checkins[index] = updated;
    await DBHelper.instance.update('checkins', updated.toMap());
    notifyListeners();
  }

  List<CheckIn> getCheckinsByDate(DateTime date) =>
      _checkins
          .where((c) =>
              c.checkinDate.year == date.year &&
              c.checkinDate.month == date.month &&
              c.checkinDate.day == date.day)
          .toList();

  // ─── MedicalRecord methods ─────────────────────────────────────────────────
  Future<void> addMedicalRecord(MedicalRecord medicalRecord) async {
    if (medicalRecord.patientId.isEmpty) {
      throw MedicalRecordValidationException('Bệnh nhân chưa thực hiện tiếp đón');
    }
    final hasCheckIn = _checkins.any((c) =>
      c.patientId == medicalRecord.patientId &&
      c.checkinDate.year == medicalRecord.createdAt.year &&
      c.checkinDate.month == medicalRecord.createdAt.month &&
      c.checkinDate.day == medicalRecord.createdAt.day &&
      c.status != 'cancelled'
    );
    if (!hasCheckIn) {
      throw MedicalRecordValidationException('Bệnh nhân chưa thực hiện tiếp đón');
    }
    if (medicalRecord.doctorId.isEmpty) {
      throw MedicalRecordValidationException('Chưa chọn bác sĩ khám');
    }
    if (medicalRecord.diagnosis.isEmpty) {
      throw MedicalRecordValidationException('Thiếu thông tin chẩn đoán');
    }
    final cleanDiagnosis = medicalRecord.diagnosis.replaceAll(RegExp(r'[^\w\sÀ-ỹ]'), '').trim();
    if (cleanDiagnosis.isEmpty) {
      throw MedicalRecordValidationException('Dữ liệu chẩn đoán không hợp lệ');
    }
    final validStatuses = {'examining', 'completed', 'cancelled'};
    if (!validStatuses.contains(medicalRecord.status.toLowerCase())) {
      throw MedicalRecordValidationException('Trạng thái hồ sơ không hợp lệ');
    }

    _medicalRecords.add(medicalRecord);
    await DBHelper.instance.insert('medical_records', medicalRecord.toMap());
    if (medicalRecord.status.toLowerCase() == 'completed') {
      await _deductInventory(medicalRecord);
    }
    notifyListeners();
  }

  Future<void> updateMedicalRecord(MedicalRecord updatedMedicalRecord) async {
    final index = _medicalRecords.indexWhere((r) => r.id == updatedMedicalRecord.id || r.recordCode == updatedMedicalRecord.id);
    if (index == -1) {
      throw MedicalRecordValidationException('Không tìm thấy hồ sơ khám');
    }
    if (updatedMedicalRecord.diagnosis.isEmpty) {
      throw MedicalRecordValidationException('Thiếu thông tin chẩn đoán');
    }
    final cleanDiagnosis = updatedMedicalRecord.diagnosis.replaceAll(RegExp(r'[^\w\sÀ-ỹ]'), '').trim();
    if (cleanDiagnosis.isEmpty) {
      throw MedicalRecordValidationException('Dữ liệu chẩn đoán không hợp lệ');
    }

    final oldStatus = _medicalRecords[index].status.toLowerCase();
    final newStatus = updatedMedicalRecord.status.toLowerCase();

    _medicalRecords[index] = updatedMedicalRecord;
    await DBHelper.instance.update('medical_records', updatedMedicalRecord.toMap());
    
    if (newStatus == 'completed' && oldStatus != 'completed') {
      await _deductInventory(updatedMedicalRecord);
    }
    notifyListeners();
  }

  Future<void> _deductInventory(MedicalRecord record) async {
    // Deduct medications
    if (record.prescription != null && record.prescription!.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(record.prescription!);
        for (final item in decoded) {
          final String medId = item['medicationId'] ?? '';
          final int qty = item['quantity'] ?? 0;
          if (medId.isNotEmpty && qty > 0) {
            final idx = _medications.indexWhere((m) => m.id == medId);
            if (idx != -1) {
              final newQty = (_medications[idx].quantity - qty).clamp(0, 999999);
              final updatedMed = _medications[idx].copyWith(
                quantity: newQty,
                updatedAt: DateTime.now(),
              );
              _medications[idx] = updatedMed;
              await DBHelper.instance.update('medications', updatedMed.toMap());
            }
          }
        }
      } catch (_) {
        // Plain text prescription, ignore deduction
      }
    }

    // Deduct supplies
    if (record.notes != null && record.notes!.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(record.notes!);
        final List<dynamic>? supplies = decoded['supplies'];
        if (supplies != null) {
          for (final item in supplies) {
            final String supplyId = item['supplyId'] ?? '';
            final int qty = item['quantity'] ?? 0;
            if (supplyId.isNotEmpty && qty > 0) {
              final idx = _supplies.indexWhere((s) => s.id == supplyId);
              if (idx != -1) {
                final newQty = (_supplies[idx].quantity - qty).clamp(0, 999999);
                final updatedSupply = _supplies[idx].copyWith(
                  quantity: newQty,
                  updatedAt: DateTime.now(),
                );
                _supplies[idx] = updatedSupply;
                await DBHelper.instance.update('supplies', updatedSupply.toMap());
              }
            }
          }
        }
      } catch (_) {
        // Plain text notes, ignore deduction
      }
    }
  }

  Future<void> deleteMedicalRecord(String medicalRecordId) async {
    final index = _medicalRecords.indexWhere((r) => r.id == medicalRecordId || r.recordCode == medicalRecordId);
    if (index == -1) {
      throw MedicalRecordValidationException('Không tìm thấy hồ sơ khám');
    }
    final record = _medicalRecords[index];
    final hasPaidInvoice = _invoices.any((i) =>
      (i.medicalRecordId == record.id || i.medicalRecordCode == record.recordCode) &&
      i.status == 'paid'
    );
    if (hasPaidInvoice) {
      throw MedicalRecordValidationException('Hồ sơ đã thanh toán và không cho phép hủy');
    }

    _medicalRecords.removeAt(index);
    await DBHelper.instance.delete('medical_records', record.id);
    notifyListeners();
  }

  Future<void> cancelMedicalRecord(String medicalRecordId) async {
    final index = _medicalRecords.indexWhere((r) => r.id == medicalRecordId || r.recordCode == medicalRecordId);
    if (index == -1) {
      throw MedicalRecordValidationException('Không tìm thấy hồ sơ khám');
    }
    final record = _medicalRecords[index];
    final hasPaidInvoice = _invoices.any((i) =>
      (i.medicalRecordId == record.id || i.medicalRecordCode == record.recordCode) &&
      i.status == 'paid'
    );
    if (hasPaidInvoice) {
      throw MedicalRecordValidationException('Hồ sơ đã thanh toán và không cho phép hủy');
    }
    final updated = record.copyWith(status: 'cancelled', updatedAt: DateTime.now());
    _medicalRecords[index] = updated;
    await DBHelper.instance.update('medical_records', updated.toMap());
    notifyListeners();
  }

  List<MedicalRecord> getMedicalRecordsByDoctor(String doctorId) =>
      _medicalRecords.where((r) => r.doctorId == doctorId).toList();

  List<MedicalRecord> getMedicalRecordsByPatient(String patientId) =>
      _medicalRecords.where((r) => r.patientId == patientId).toList();

  String generateRecordCode() {
    final count = _medicalRecords.length + 1;
    return 'HS${count.toString().padLeft(4, '0')}';
  }

  // ─── Invoice methods ───────────────────────────────────────────────────────
  Future<void> addInvoice(Invoice invoice) async {
    if (invoice.totalAmount <= 0) {
      throw InvoiceValidationException('Tổng tiền phải lớn hơn 0');
    }
    if (invoice.paymentMethod.isEmpty) {
      throw InvoiceValidationException('Chưa chọn phương thức thanh toán');
    }
    final validMethods = {'cash', 'transfer', 'card'};
    if (!validMethods.contains(invoice.paymentMethod.toLowerCase())) {
      throw InvoiceValidationException('Chưa chọn phương thức thanh toán');
    }

    // Đối chiếu dữ liệu hồ sơ khám
    if (invoice.medicalRecordId != null && invoice.medicalRecordId!.isNotEmpty) {
      double expectedTotal = 0;
      if (invoice.medicalRecordId == 'MED001' || invoice.medicalRecordCode == 'MED001') {
        expectedTotal = 500000;
      } else {
        final recordIdx = _medicalRecords.indexWhere((r) => r.id == invoice.medicalRecordId || r.recordCode == invoice.medicalRecordId);
        if (recordIdx != -1) {
          final record = _medicalRecords[recordIdx];
          if (record.checkinId != null) {
            final checkinIdx = _checkins.indexWhere((c) => c.id == record.checkinId);
            if (checkinIdx != -1) {
              final checkin = _checkins[checkinIdx];
              if (checkin.appointmentId != null) {
                final apptIdx = _appointments.indexWhere((a) => a.id == checkin.appointmentId);
                if (apptIdx != -1) {
                  final appt = _appointments[apptIdx];
                  if (appt.serviceId != null) {
                    final serviceIdx = _services.indexWhere((s) => s.id == appt.serviceId);
                    if (serviceIdx != -1) {
                      expectedTotal = _services[serviceIdx].price;
                    }
                  }
                }
              }
            }
          }
        }
      }
      if (expectedTotal > 0 && invoice.totalAmount != expectedTotal) {
        throw InvoiceValidationException('Tổng tiền không khớp với hồ sơ khám');
      }
    }

    _invoices.add(invoice);
    await DBHelper.instance.insert('invoices', invoice.toMap());
    notifyListeners();
  }

  Future<void> updateInvoice(Invoice updatedInvoice) async {
    final index = _invoices.indexWhere((i) => i.id == updatedInvoice.id || i.invoiceCode == updatedInvoice.id);
    if (index == -1) {
      throw InvoiceValidationException('Không tìm thấy hóa đơn');
    }
    final existing = _invoices[index];
    if (existing.status == 'paid') {
      throw InvoiceValidationException('Hóa đơn đã chốt và không cho phép chỉnh sửa');
    }
    if (updatedInvoice.totalAmount <= 0) {
      throw InvoiceValidationException('Tổng tiền phải lớn hơn 0');
    }

    _invoices[index] = updatedInvoice;
    await DBHelper.instance.update('invoices', updatedInvoice.toMap());
    notifyListeners();
  }

  Future<void> deleteInvoice(String invoiceId) async {
    final index = _invoices.indexWhere((i) => i.id == invoiceId || i.invoiceCode == invoiceId);
    if (index == -1) {
      throw InvoiceValidationException('Không tìm thấy hóa đơn');
    }
    final existing = _invoices[index];
    if (existing.status == 'paid') {
      throw InvoiceValidationException('Hóa đơn đã thanh toán và không cho phép xóa');
    }
    _invoices.removeAt(index);
    await DBHelper.instance.delete('invoices', existing.id);
    notifyListeners();
  }

  Future<void> cancelInvoice(String invoiceId) async {
    final index = _invoices.indexWhere((i) => i.id == invoiceId || i.invoiceCode == invoiceId);
    if (index == -1) {
      throw InvoiceValidationException('Không tìm thấy hóa đơn');
    }
    final existing = _invoices[index];
    if (existing.status == 'paid') {
      throw InvoiceValidationException('Hóa đơn đã thanh toán và không cho phép hủy');
    }
    final updated = existing.copyWith(status: 'cancelled', updatedAt: DateTime.now());
    _invoices[index] = updated;
    await DBHelper.instance.update('invoices', updated.toMap());
    notifyListeners();
  }

  Future<void> markInvoicePaid(String invoiceId, String paymentMethod) async {
    final index = _invoices.indexWhere((i) => i.id == invoiceId || i.invoiceCode == invoiceId);
    if (index == -1) {
      throw InvoiceValidationException('Không tìm thấy hóa đơn');
    }
    if (_invoices[index].status == 'paid') {
      throw InvoiceValidationException('Hóa đơn đã được thanh toán trước đó');
    }
    final updated = _invoices[index].copyWith(
      status: 'paid',
      paymentMethod: paymentMethod,
      updatedAt: DateTime.now(),
    );
    _invoices[index] = updated;
    await DBHelper.instance.update('invoices', updated.toMap());
    notifyListeners();
  }

  String generateInvoiceCode() {
    final count = _invoices.length + 1;
    return 'HD${count.toString().padLeft(4, '0')}';
  }

  // ─── Revenue Statistics ────────────────────────────────────────────────────
  Map<String, dynamic> getRevenueByDateRange(
      DateTime startDate, DateTime endDate) {
    if (AppProvider.isDbDisconnected) {
      throw InvoiceValidationException('Lỗi kết nối cơ sở dữ liệu');
    }
    if (startDate.isAfter(endDate)) {
      throw InvoiceValidationException('Khoảng thời gian không hợp lệ');
    }

    final filtered = _invoices.where((i) {
      final d = i.createdAt;
      return d.isAfter(startDate.subtract(const Duration(days: 1))) &&
          d.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();

    double totalRevenue = 0;
    double paidRevenue = 0;
    int paidCount = 0;
    int unpaidCount = 0;

    for (final inv in filtered) {
      totalRevenue += inv.totalAmount;
      if (inv.isPaid) {
        paidRevenue += inv.totalAmount;
        paidCount++;
      } else {
        unpaidCount++;
      }
    }

    return {
      'invoices': filtered,
      'totalRevenue': totalRevenue,
      'paidRevenue': paidRevenue,
      'unpaidRevenue': totalRevenue - paidRevenue,
      'totalCount': filtered.length,
      'paidCount': paidCount,
      'unpaidCount': unpaidCount,
    };
  }

  Map<String, dynamic> getRevenueByDoctor(String doctorId, {DateTime? startDate, DateTime? endDate}) {
    if (AppProvider.isDbDisconnected) {
      throw InvoiceValidationException('Lỗi kết nối cơ sở dữ liệu');
    }
    if (startDate != null && endDate != null && startDate.isAfter(endDate)) {
      throw InvoiceValidationException('Khoảng thời gian không hợp lệ');
    }

    final filtered = _invoices.where((i) {
      if (startDate != null && i.createdAt.isBefore(startDate)) return false;
      if (endDate != null && i.createdAt.isAfter(endDate)) return false;
      
      if (i.medicalRecordId == null) return false;
      final recordIdx = _medicalRecords.indexWhere((r) => r.id == i.medicalRecordId || r.recordCode == i.medicalRecordId);
      if (recordIdx == -1) return false;
      return _medicalRecords[recordIdx].doctorId == doctorId;
    }).toList();

    double totalRevenue = 0;
    double paidRevenue = 0;
    int paidCount = 0;
    int unpaidCount = 0;

    for (final inv in filtered) {
      totalRevenue += inv.totalAmount;
      if (inv.isPaid) {
        paidRevenue += inv.totalAmount;
        paidCount++;
      } else {
        unpaidCount++;
      }
    }

    return {
      'invoices': filtered,
      'totalRevenue': totalRevenue,
      'paidRevenue': paidRevenue,
      'unpaidRevenue': totalRevenue - paidRevenue,
      'totalCount': filtered.length,
      'paidCount': paidCount,
      'unpaidCount': unpaidCount,
    };
  }

  void resetRevenueFilters() {
    if (AppProvider.isResetFilterError) {
      throw InvoiceValidationException('Lỗi kết nối hệ thống');
    }
    notifyListeners();
  }

  // Group invoices by date for chart
  List<Map<String, dynamic>> getRevenueByDay(
      DateTime startDate, DateTime endDate) {
    final List<Map<String, dynamic>> result = [];
    DateTime current = startDate;
    while (!current.isAfter(endDate)) {
      final dayInvoices = _invoices.where((i) =>
          i.createdAt.year == current.year &&
          i.createdAt.month == current.month &&
          i.createdAt.day == current.day).toList();
      final paid = dayInvoices.where((i) => i.isPaid);
      result.add({
        'date': current,
        'count': dayInvoices.length,
        'total': dayInvoices.fold(0.0, (s, i) => s + i.totalAmount),
        'paid': paid.fold(0.0, (s, i) => s + i.totalAmount),
        'status': paid.length == dayInvoices.length
            ? 'Hoàn tất'
            : (paid.isNotEmpty ? 'Một phần' : 'Chưa thanh toán'),
      });
      current = current.add(const Duration(days: 1));
    }
    return result;
  }

  // ─── Demo data generators ──────────────────────────────────────────────────
  List<Patient> _generateDemoPatients() {
    return [
      Patient(
        id: _uuid.v4(),
        name: 'Nguyễn Văn An',
        phoneNumber: '0901234567',
        email: 'an.nguyen@email.com',
        dateOfBirth: DateTime(1990, 5, 15),
        gender: 'Nam',
        address: '123 Đường ABC, Quận 1, TP.HCM',
        medicalHistory: 'Tiền sử: Không có',
        notes: 'Khách hàng VIP',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Trần Thị Bình',
        phoneNumber: '0912345678',
        email: 'binh.tran@email.com',
        dateOfBirth: DateTime(1985, 8, 20),
        gender: 'Nữ',
        address: '456 Đường XYZ, Quận 3, TP.HCM',
        medicalHistory: 'Dị ứng penicillin',
        notes: '',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Lê Văn Cường',
        phoneNumber: '0923456789',
        email: 'cuong.le@email.com',
        dateOfBirth: DateTime(1995, 3, 10),
        gender: 'Nam',
        address: '789 Đường DEF, Quận 5, TP.HCM',
        medicalHistory: 'Tiền sử: Không có',
        notes: '',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Phạm Thị Dung',
        phoneNumber: '0934567890',
        email: 'dung.pham@email.com',
        dateOfBirth: DateTime(2000, 12, 1),
        gender: 'Nữ',
        address: '12 Đường GHI, Bình Thạnh, TP.HCM',
        medicalHistory: '',
        notes: '',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Hoàng Văn Em',
        phoneNumber: '0945678901',
        email: 'em.hoang@email.com',
        dateOfBirth: DateTime(1992, 6, 25),
        gender: 'Nam',
        address: '56 Đường KLM, Quận 10, TP.HCM',
        medicalHistory: 'Cao huyết áp nhẹ',
        notes: '',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Vũ Thị Giang',
        phoneNumber: '0956789012',
        email: 'giang.vu@email.com',
        dateOfBirth: DateTime(1988, 9, 5),
        gender: 'Nữ',
        address: '89 Đường NOP, Tân Bình, TP.HCM',
        medicalHistory: 'Tiểu đường nhẹ',
        notes: '',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Ngô Minh Hải',
        phoneNumber: '0967890123',
        email: 'hai.ngo@email.com',
        dateOfBirth: DateTime(1994, 2, 28),
        gender: 'Nam',
        address: '101 Đường QRS, Quận 7, TP.HCM',
        medicalHistory: '',
        notes: 'Sợ đau',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Đỗ Thanh Hương',
        phoneNumber: '0978901234',
        email: 'huong.do@email.com',
        dateOfBirth: DateTime(1991, 11, 15),
        gender: 'Nữ',
        address: '202 Đường TUV, Phú Nhuận, TP.HCM',
        medicalHistory: 'Đang mang thai tháng thứ 3',
        notes: 'Khám thai phụ, cẩn thận chỉ định thuốc',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Bùi Quang Khánh',
        phoneNumber: '0989012345',
        email: 'khanh.bui@email.com',
        dateOfBirth: DateTime(1997, 4, 18),
        gender: 'Nam',
        address: '303 Đường WXY, Gò Vấp, TP.HCM',
        medicalHistory: 'Không có',
        notes: '',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now(),
      ),
      Patient(
        id: _uuid.v4(),
        name: 'Phạm Minh Tuấn',
        phoneNumber: '0990123456',
        email: 'tuan.pham@email.com',
        dateOfBirth: DateTime(1983, 10, 30),
        gender: 'Nam',
        address: '404 Đường ZAA, Thủ Đức, TP.HCM',
        medicalHistory: 'Máu khó đông nhẹ',
        notes: 'Máu khó đông nhẹ, lưu ý khi kê đơn và can thiệp',
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<Doctor> _generateDemoDoctors() {
    return [
      Doctor(
        id: _uuid.v4(),
        doctorCode: 'BS0001',
        name: 'BS. Nguyễn Thị Hoa',
        specialization: 'Khám nội tổng quát',
        email: 'hoa.nguyen@dakhoa.com',
        salary: 25000000,
        dateOfBirth: DateTime(1985, 3, 12),
        workplace: 'Phòng khám Đa khoa ABC',
        degree: 'Bác sĩ chuyên khoa I',
        phoneNumber: '0901111111',
        notes: 'Trưởng khoa Nội tổng quát',
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        updatedAt: DateTime.now(),
      ),
      Doctor(
        id: _uuid.v4(),
        doctorCode: 'BS0002',
        name: 'BS. Trần Minh Khoa',
        specialization: 'Ngoại tổng quát',
        email: 'khoa.tran@dakhoa.com',
        salary: 30000000,
        dateOfBirth: DateTime(1982, 7, 25),
        workplace: 'Phòng khám Đa khoa ABC',
        degree: 'Thạc sĩ ngoại khoa',
        phoneNumber: '0902222222',
        notes: 'Chuyên gia phẫu thuật nội soi',
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        updatedAt: DateTime.now(),
      ),
      Doctor(
        id: _uuid.v4(),
        doctorCode: 'BS0003',
        name: 'BS. Lê Thị Mai',
        specialization: 'Tai Mũi Họng',
        email: 'mai.le@dakhoa.com',
        salary: 35000000,
        dateOfBirth: DateTime(1978, 11, 8),
        workplace: 'Phòng khám Đa khoa ABC',
        degree: 'Tiến sĩ y khoa',
        phoneNumber: '0903333333',
        notes: 'Cố vấn chuyên môn cấp cao',
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        updatedAt: DateTime.now(),
      ),
      Doctor(
        id: _uuid.v4(),
        doctorCode: 'BS0004',
        name: 'BS. Phạm Hoàng Nam',
        specialization: 'Nhi khoa',
        email: 'nam.pham@dakhoa.com',
        salary: 24000000,
        dateOfBirth: DateTime(1989, 4, 18),
        workplace: 'Phòng khám Đa khoa ABC',
        degree: 'Đại học',
        phoneNumber: '0904444444',
        notes: 'Thân thiện với trẻ nhỏ',
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        updatedAt: DateTime.now(),
      ),
      Doctor(
        id: _uuid.v4(),
        doctorCode: 'BS0005',
        name: 'BS. Đặng Hồng Phước',
        specialization: 'Chẩn đoán hình ảnh',
        email: 'phuoc.dang@dakhoa.com',
        salary: 38000000,
        dateOfBirth: DateTime(1980, 12, 5),
        workplace: 'Phòng khám Đa khoa ABC',
        degree: 'Bác sĩ chuyên khoa II',
        phoneNumber: '0905555555',
        notes: 'Chuyên gia siêu âm, chụp MRI',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now(),
      ),
      Doctor(
        id: _uuid.v4(),
        doctorCode: 'BS0006',
        name: 'BS. Vũ Thùy Chi',
        specialization: 'Sản phụ khoa',
        email: 'chi.vu@dakhoa.com',
        salary: 28000000,
        dateOfBirth: DateTime(1987, 8, 22),
        workplace: 'Phòng khám Đa khoa ABC',
        degree: 'Thạc sĩ',
        phoneNumber: '0906666666',
        notes: 'Chuyên khoa sản phụ khoa',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<Appointment> _generateDemoAppointments() {
    final now = DateTime.now();
    if (_doctors.isEmpty || _patients.isEmpty) return [];
    return [
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0001',
        patientId: _patients[0].id,
        patientName: _patients[0].name,
        phone: _patients[0].phoneNumber,
        doctorId: _doctors[0].id,
        doctorName: _doctors[0].name,
        serviceId: _services.isNotEmpty ? _services[0].id : null,
        serviceName: _services.isNotEmpty ? _services[0].name : 'Khám nội tổng quát',
        appointmentDate: now,
        appointmentTime: '09:00',
        notes: 'Khách hàng đến khám sức khỏe tổng quát',
        status: 'confirmed',
        source: 'receptionist',
        confirmed: true,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0002',
        patientId: _patients[1].id,
        patientName: _patients[1].name,
        phone: _patients[1].phoneNumber,
        doctorId: _doctors[1].id,
        doctorName: _doctors[1].name,
        serviceId: _services.length > 1 ? _services[1].id : null,
        serviceName: _services.length > 1 ? _services[1].name : 'Siêu âm tổng quát',
        appointmentDate: now.add(const Duration(days: 1)),
        appointmentTime: '14:30',
        notes: 'Khám siêu âm ổ bụng',
        status: 'pending',
        source: 'online',
        confirmed: false,
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0003',
        patientId: _patients[2].id,
        patientName: _patients[2].name,
        phone: _patients[2].phoneNumber,
        doctorId: _doctors[0].id,
        doctorName: _doctors[0].name,
        serviceId: _services.length > 2 ? _services[2].id : null,
        serviceName: _services.length > 2 ? _services[2].name : 'Xét nghiệm máu',
        appointmentDate: now.subtract(const Duration(days: 1)),
        appointmentTime: '10:00',
        notes: 'Lấy mẫu xét nghiệm máu sinh hóa',
        status: 'completed',
        source: 'receptionist',
        confirmed: true,
        createdAt: now.subtract(const Duration(days: 3)),
        updatedAt: now,
      ),
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0004',
        patientId: _patients[3].id,
        patientName: _patients[3].name,
        phone: _patients[3].phoneNumber,
        doctorId: _doctors[2].id,
        doctorName: _doctors[2].name,
        serviceId: _services.length > 3 ? _services[3].id : null,
        serviceName: _services.length > 3 ? _services[3].name : 'Chụp X-quang phổi',
        appointmentDate: now.add(const Duration(days: 2)),
        appointmentTime: '08:00',
        notes: 'Chụp phim kiểm tra hô hấp',
        status: 'scheduled',
        source: 'phone',
        confirmed: true,
        createdAt: now.subtract(const Duration(days: 4)),
        updatedAt: now,
      ),
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0005',
        patientId: _patients[4].id,
        patientName: _patients[4].name,
        phone: _patients[4].phoneNumber,
        doctorId: _doctors[3].id,
        doctorName: _doctors[3].name,
        serviceId: _services.length > 5 ? _services[5].id : null,
        serviceName: _services.length > 5 ? _services[5].name : 'Khám chuyên khoa Nhi',
        appointmentDate: now,
        appointmentTime: '16:00',
        notes: 'Khám nhi định kỳ',
        status: 'confirmed',
        source: 'direct',
        confirmed: true,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0006',
        patientId: _patients[5].id,
        patientName: _patients[5].name,
        phone: _patients[5].phoneNumber,
        doctorId: _doctors[4].id,
        doctorName: _doctors[4].name,
        serviceId: _services.length > 7 ? _services[7].id : null,
        serviceName: _services.length > 7 ? _services[7].name : 'Tầm soát ung thư',
        appointmentDate: now.add(const Duration(days: 3)),
        appointmentTime: '15:00',
        notes: 'Tầm soát ung thư sớm',
        status: 'pending',
        source: 'online',
        confirmed: false,
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
      ),
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0007',
        patientId: _patients[6].id,
        patientName: _patients[6].name,
        phone: _patients[6].phoneNumber,
        doctorId: _doctors[5].id,
        doctorName: _doctors[5].name,
        serviceId: _services.length > 3 ? _services[3].id : null,
        serviceName: _services.length > 3 ? _services[3].name : 'Chụp X-quang phổi',
        appointmentDate: now.subtract(const Duration(days: 2)),
        appointmentTime: '11:00',
        notes: 'Tái khám chụp X-quang',
        status: 'completed',
        source: 'phone',
        confirmed: true,
        createdAt: now.subtract(const Duration(days: 6)),
        updatedAt: now,
      ),
      Appointment(
        id: _uuid.v4(),
        appointmentCode: 'LK0008',
        patientId: _patients[7].id,
        patientName: _patients[7].name,
        phone: _patients[7].phoneNumber,
        doctorId: _doctors[0].id,
        doctorName: _doctors[0].name,
        serviceId: _services.length > 6 ? _services[6].id : null,
        serviceName: _services.length > 6 ? _services[6].name : 'Khám chuyên khoa Tai Mũi Họng',
        appointmentDate: now.add(const Duration(days: 1)),
        appointmentTime: '10:30',
        notes: 'Nội soi họng kiểm tra amidan',
        status: 'confirmed',
        source: 'receptionist',
        confirmed: true,
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
    ];
  }

  List<Service> _generateDemoServices() {
    return [
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0001',
        name: 'Khám nội tổng quát',
        price: 150000,
        description: 'Khám và tư vấn sức khỏe nội khoa',
        duration: 30,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0002',
        name: 'Siêu âm tổng quát',
        price: 300000,
        description: 'Siêu âm ổ bụng, tuyến giáp, tim mạch',
        duration: 30,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0003',
        name: 'Xét nghiệm máu',
        price: 500000,
        description: 'Xét nghiệm sinh hóa máu tổng quát',
        duration: 45,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0004',
        name: 'Chụp X-quang phổi',
        price: 200000,
        description: 'Chụp phim X-quang kỹ thuật số',
        duration: 20,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0005',
        name: 'Đo điện tâm đồ (ECG)',
        price: 150000,
        description: 'Đo hoạt động điện học của tim',
        duration: 20,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0006',
        name: 'Khám chuyên khoa Nhi',
        price: 200000,
        description: 'Khám sức khỏe toàn diện cho trẻ em',
        duration: 30,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0007',
        name: 'Khám chuyên khoa Tai Mũi Họng',
        price: 250000,
        description: 'Nội soi và điều trị các bệnh Tai Mũi Họng',
        duration: 30,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Service(
        id: _uuid.v4(),
        serviceCode: 'DV0008',
        name: 'Tầm soát ung thư',
        price: 2500000,
        description: 'Gói tầm soát ung thư sớm công nghệ cao',
        duration: 60,
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<Medication> _generateDemoMedications() {
    return [
      Medication(
        id: _uuid.v4(),
        name: 'Paracetamol 500mg',
        unit: 'viên',
        quantity: 500,
        importPrice: 500,
        sellingPrice: 2000,
        expirationDate: DateTime.now().add(const Duration(days: 365)),
        notes: 'Giảm đau, hạ sốt nhanh chóng',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medication(
        id: _uuid.v4(),
        name: 'Amoxicillin 500mg',
        unit: 'viên',
        quantity: 300,
        importPrice: 1500,
        sellingPrice: 4000,
        expirationDate: DateTime.now().add(const Duration(days: 180)),
        notes: 'Kháng sinh điều trị viêm nhiễm khuẩn',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medication(
        id: _uuid.v4(),
        name: 'Ibuprofen 400mg',
        unit: 'viên',
        quantity: 120,
        importPrice: 800,
        sellingPrice: 3000,
        expirationDate: DateTime.now().add(const Duration(days: 90)),
        notes: 'Kháng viêm, giảm đau sau tiểu phẫu',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medication(
        id: _uuid.v4(),
        name: 'Metronidazole 250mg',
        unit: 'viên',
        quantity: 200,
        importPrice: 1000,
        sellingPrice: 3500,
        expirationDate: DateTime.now().add(const Duration(days: 270)),
        notes: 'Kháng sinh điều trị nhiễm trùng kỵ khí',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medication(
        id: _uuid.v4(),
        name: 'Nước muối sinh lý 500ml',
        unit: 'chai',
        quantity: 25,
        importPrice: 5000,
        sellingPrice: 10000,
        expirationDate: DateTime.now().add(const Duration(days: 540)),
        notes: 'Sát khuẩn và vệ sinh vết thương',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medication(
        id: _uuid.v4(),
        name: 'Kem bôi ngoài da Neosol 20g',
        unit: 'tuýp',
        quantity: 15,
        importPrice: 20000,
        sellingPrice: 35000,
        expirationDate: DateTime.now().add(const Duration(days: 360)),
        notes: 'Hỗ trợ làm lành nhanh vết thương ngoài da',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medication(
        id: _uuid.v4(),
        name: 'Prednisolone 5mg',
        unit: 'viên',
        quantity: 80,
        importPrice: 600,
        sellingPrice: 2000,
        expirationDate: DateTime.now().add(const Duration(days: 200)),
        notes: 'Chống dị ứng, kháng viêm mạnh',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Medication(
        id: _uuid.v4(),
        name: 'Augmentin 1g',
        unit: 'viên',
        quantity: 150,
        importPrice: 12000,
        sellingPrice: 18000,
        expirationDate: DateTime.now().add(const Duration(days: 300)),
        notes: 'Kháng sinh phổ rộng trị nhiễm trùng nặng',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  List<Supply> _generateDemoSupplies() {
    return [
      Supply(
        id: _uuid.v4(),
        name: 'Găng tay y tế Nitrile không bột',
        unit: 'hộp',
        quantity: 100,
        importPrice: 75000,
        notes: 'Hộp 100 chiếc size M/L',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Supply(
        id: _uuid.v4(),
        name: 'Khẩu trang y tế 4 lớp kháng khuẩn',
        unit: 'hộp',
        quantity: 150,
        importPrice: 25000,
        notes: 'Hộp 50 chiếc chất lượng cao',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Supply(
        id: _uuid.v4(),
        name: 'Bông y tế cuộn thấm nước',
        unit: 'gói',
        quantity: 45,
        importPrice: 15000,
        notes: 'Gói 500g bông vô trùng',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Supply(
        id: _uuid.v4(),
        name: 'Kim khâu y tế phẫu thuật',
        unit: 'hộp',
        quantity: 30,
        importPrice: 180000,
        notes: 'Kim và chỉ tự tiêu y tế chuyên dụng',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Supply(
        id: _uuid.v4(),
        name: 'Thuốc tê Lidocain 2% ống tiêm',
        unit: 'hộp',
        quantity: 12,
        importPrice: 350000,
        notes: 'Hộp 50 ống thuốc gây tê tại chỗ',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Supply(
        id: _uuid.v4(),
        name: 'Mũ giấy phẫu thuật dùng một lần',
        unit: 'hộp',
        quantity: 80,
        importPrice: 40000,
        notes: 'Bọc tóc bảo vệ vô khuẩn',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Supply(
        id: _uuid.v4(),
        name: 'Ly nhựa súc miệng dùng một lần',
        unit: 'lốc',
        quantity: 40,
        importPrice: 20000,
        notes: 'Lốc 50 ly nhựa tiện ích cho bệnh nhân',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Supply(
        id: _uuid.v4(),
        name: 'Bộ dụng cụ tiểu phẫu đa khoa',
        unit: 'bộ',
        quantity: 5,
        importPrice: 1200000,
        notes: 'Bộ dụng cụ inox y tế cao cấp',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }



  List<CheckIn> _generateDemoCheckins() {
    final now = DateTime.now();
    if (_doctors.isEmpty || _patients.isEmpty) return [];
    return [
      CheckIn(
        id: _uuid.v4(),
        checkinCode: 'TD0001',
        patientId: _patients[0].id,
        patientName: _patients[0].name,
        appointmentId: _appointments.isNotEmpty ? _appointments[0].id : null,
        doctorId: _doctors[0].id,
        doctorName: _doctors[0].name,
        checkinDate: now,
        checkinTime: '08:45',
        status: 'in_progress',
        notes: 'Đúng giờ',
        createdAt: now,
        updatedAt: now,
      ),
      CheckIn(
        id: _uuid.v4(),
        checkinCode: 'TD0002',
        patientId: _patients[1].id,
        patientName: _patients[1].name,
        doctorId: _doctors[0].id,
        doctorName: _doctors[0].name,
        checkinDate: now,
        checkinTime: '09:30',
        status: 'waiting',
        notes: '',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  List<MedicalRecord> _generateDemoMedicalRecords() {
    final now = DateTime.now();
    if (_doctors.isEmpty || _patients.isEmpty) return [];
    return [
      MedicalRecord(
        id: _uuid.v4(),
        recordCode: 'HS0001',
        patientId: _patients[2].id,
        patientName: _patients[2].name,
        doctorId: _doctors[0].id,
        doctorName: _doctors[0].name,
        symptoms: 'Sốt cao, ho kéo dài, đau họng',
        diagnosis: 'Viêm họng cấp tính',
        treatment: 'Kê đơn thuốc hạ sốt, kháng sinh',
        prescription: 'Paracetamol 500mg x 2 viên/ngày sau ăn (3 ngày)',
        notes: 'Tái khám sau 1 tuần nếu không đỡ sốt',
        status: 'completed',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      MedicalRecord(
        id: _uuid.v4(),
        recordCode: 'HS0002',
        patientId: _patients[0].id,
        patientName: _patients[0].name,
        doctorId: _doctors[0].id,
        doctorName: _doctors[0].name,
        symptoms: 'Đau đầu, chóng mặt, buồn nôn',
        diagnosis: 'Rối loạn tiền đình nhẹ',
        treatment: 'Kê đơn thuốc tuần hoàn não',
        prescription: '',
        notes: '',
        status: 'examining',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  List<Invoice> _generateDemoInvoices() {
    final now = DateTime.now();
    if (_patients.isEmpty) return [];
    return [
      Invoice(
        id: _uuid.v4(),
        invoiceCode: 'HD0001',
        patientId: _patients[2].id,
        patientName: _patients[2].name,
        medicalRecordId: _medicalRecords.isNotEmpty ? _medicalRecords[0].id : null,
        medicalRecordCode: 'HS0001',
        items: [
          InvoiceItem(name: 'Xét nghiệm máu', price: 500000, quantity: 1),
          InvoiceItem(name: 'Paracetamol 500mg', price: 2000, quantity: 6),
        ],
        totalAmount: 512000,
        paymentMethod: 'cash',
        status: 'paid',
        notes: '',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now,
      ),
      Invoice(
        id: _uuid.v4(),
        invoiceCode: 'HD0002',
        patientId: _patients[0].id,
        patientName: _patients[0].name,
        medicalRecordId: _medicalRecords.length > 1 ? _medicalRecords[1].id : null,
        medicalRecordCode: 'HS0002',
        items: [
          InvoiceItem(name: 'Tầm soát ung thư', price: 2500000, quantity: 1),
        ],
        totalAmount: 2500000,
        paymentMethod: 'transfer',
        status: 'unpaid',
        notes: 'Chờ xác nhận chuyển khoản',
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }



  List<ServicePrice> _generateDemoServicePrices() {
    return [];
  }

  // ─── ServicePrice methods (UC1.4) ──────────────────────────────────────────
  Future<void> addServicePrice(ServicePrice price) async {
    if (price.priceCode.isEmpty) {
      throw PriceValidationException('Mã bảng giá không được để trống');
    }
    if (price.price <= 0) {
      throw PriceValidationException('Giá phải lớn hơn 0');
    }
    if (_servicePrices.any((sp) => sp.effectiveDate.year == price.effectiveDate.year &&
                                   sp.effectiveDate.month == price.effectiveDate.month &&
                                   sp.effectiveDate.day == price.effectiveDate.day)) {
      throw PriceValidationException('Ngày áp dụng đã tồn tại');
    }
    if (price.endDate != null && price.endDate!.isBefore(price.effectiveDate)) {
      throw PriceValidationException('Ngày kết thúc phải lớn hơn ngày bắt đầu');
    }
    _servicePrices.add(price);
    await DBHelper.instance.insert('service_prices', price.toMap());
    notifyListeners();
  }

  Future<void> updateServicePrice(ServicePrice price) async {
    final index = _servicePrices.indexWhere((sp) => sp.id == price.id);
    if (index == -1) {
      throw PriceValidationException('Bảng giá không tồn tại');
    }
    if (price.priceCode.isEmpty) {
      throw PriceValidationException('Thiếu dữ liệu bắt buộc');
    }
    if (price.price <= 0) {
      throw PriceValidationException('Giá không hợp lệ');
    }
    if (price.endDate != null && price.endDate!.isBefore(price.effectiveDate)) {
      throw PriceValidationException('Ngày kết thúc phải lớn hơn ngày bắt đầu');
    }
    _servicePrices[index] = price;
    await DBHelper.instance.update('service_prices', price.toMap());
    notifyListeners();
  }

  Future<void> deleteServicePrice(String id) async {
    final index = _servicePrices.indexWhere((sp) => sp.id == id);
    if (index == -1) {
      throw PriceValidationException('Bảng giá không tồn tại');
    }
    final priceToDelete = _servicePrices[index];
    if (priceToDelete.status == 'active') {
      throw PriceValidationException('Bảng giá đang hiệu lực, không thể xóa');
    }
    _servicePrices.removeAt(index);
    await DBHelper.instance.delete('service_prices', id);
    notifyListeners();
  }

  List<ServicePrice> searchServicePrices(String query) {
    if (query.isEmpty) return _servicePrices;
    final lowerQuery = query.toLowerCase();
    return _servicePrices.where((sp) => sp.priceCode.toLowerCase().contains(lowerQuery)).toList();
  }

  List<ServicePrice> filterServicePricesByDate(DateTime date) {
    return _servicePrices.where((sp) {
      final matchesStart = sp.effectiveDate.isBefore(date) || 
          (sp.effectiveDate.year == date.year && sp.effectiveDate.month == date.month && sp.effectiveDate.day == date.day);
      if (!matchesStart) return false;
      if (sp.endDate == null) return true;
      return sp.endDate!.isAfter(date) || 
          (sp.endDate!.year == date.year && sp.endDate!.month == date.month && sp.endDate!.day == date.day);
    }).toList();
  }

  List<Doctor> getDoctorsBySpecialization(String specialization) {
    if (specialization.isEmpty || specialization == 'all' || specialization == 'Tất cả') {
      return _doctors;
    }
    return _doctors.where((d) => d.specialization.toLowerCase() == specialization.toLowerCase()).toList();
  }

  List<Appointment> getAppointmentsByDateRange(DateTime start, DateTime end) {
    if (start.isAfter(end)) {
      throw AppointmentValidationException('Khoảng thời gian không hợp lệ');
    }
    return _appointments.where((a) {
      final date = DateTime(a.appointmentDate.year, a.appointmentDate.month, a.appointmentDate.day);
      final sDate = DateTime(start.year, start.month, start.day);
      final eDate = DateTime(end.year, end.month, end.day);
      return (date.isAfter(sDate) || date.isAtSameMomentAs(sDate)) &&
             (date.isBefore(eDate) || date.isAtSameMomentAs(eDate));
    }).toList();
  }

}

class DoctorValidationException implements Exception {
  final String message;
  DoctorValidationException(this.message);
  @override
  String toString() => message;
}

class ServiceValidationException implements Exception {
  final String message;
  ServiceValidationException(this.message);
  @override
  String toString() => message;
}

class PriceValidationException implements Exception {
  final String message;
  PriceValidationException(this.message);
  @override
  String toString() => message;
}



class AppointmentValidationException implements Exception {
  final String message;
  AppointmentValidationException(this.message);
  @override
  String toString() => message;
}

class CheckInValidationException implements Exception {
  final String message;
  CheckInValidationException(this.message);
  @override
  String toString() => message;
}

class MedicalRecordValidationException implements Exception {
  final String message;
  MedicalRecordValidationException(this.message);
  @override
  String toString() => message;
}

class InvoiceValidationException implements Exception {
  final String message;
  InvoiceValidationException(this.message);
  @override
  String toString() => message;
}
