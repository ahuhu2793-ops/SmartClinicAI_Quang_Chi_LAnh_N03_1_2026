import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/appointment.dart';
import '../models/checkin.dart';
import '../theme/app_theme.dart';

class CheckInFormScreen extends StatefulWidget {
  final CheckIn? checkIn;
  const CheckInFormScreen({Key? key, this.checkIn}) : super(key: key);

  @override
  State<CheckInFormScreen> createState() => _CheckInFormScreenState();
}

class _CheckInFormScreenState extends State<CheckInFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _checkinCodeCtrl = TextEditingController();

  String? _selectedPatientId;
  String? _selectedPatientName;
  String? _selectedDoctorId;
  String? _selectedDoctorName;
  String? _selectedAppointmentId;
  DateTime _checkinDate = DateTime.now();
  TimeOfDay _checkinTime = TimeOfDay.now();
  String _status = 'waiting';
  bool _isLoading = false;

  bool get isEdit => widget.checkIn != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final c = widget.checkIn!;
      _checkinCodeCtrl.text = c.checkinCode;
      _selectedPatientId = c.patientId;
      _selectedPatientName = c.patientName;
      _notesCtrl.text = c.notes ?? '';
      _selectedDoctorId = c.doctorId;
      _selectedDoctorName = c.doctorName;
      _selectedAppointmentId = c.appointmentId;
      _checkinDate = c.checkinDate;
      _status = c.status;
      final timeParts = c.checkinTime.split(':');
      _checkinTime = TimeOfDay(
          hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _checkinCodeCtrl.text.isEmpty) {
          final provider = context.read<AppProvider>();
          _checkinCodeCtrl.text = provider.generateCheckInCode();
        }
      });
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _checkinCodeCtrl.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  List<Appointment> _appointmentsForDate(AppProvider provider) {
    return provider
        .getAppointmentsByDate(_checkinDate)
        .where((a) => a.status != 'cancelled' && a.status != 'completed')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Cập nhật tiếp đón' : 'Thêm phiếu tiếp đón'),
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final dateAppointments = _appointmentsForDate(provider);

          if (_selectedAppointmentId != null &&
              !dateAppointments.any((a) => a.id == _selectedAppointmentId)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedAppointmentId = null);
            });
          }

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _checkinCodeCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Mã phiếu',
                    prefixIcon: const Icon(Icons.receipt_long),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedPatientId,
                  decoration: InputDecoration(
                    labelText: 'Bệnh nhân *',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: provider.patients
                      .map((p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(p.name),
                          ))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedPatientId = v;
                      if (v != null) {
                        final patient =
                            provider.patients.firstWhere((p) => p.id == v);
                        _selectedPatientName = patient.name;
                      }
                    });
                  },
                  validator: (v) => v == null ? 'Chọn bệnh nhân' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedAppointmentId,
                  decoration: InputDecoration(
                    labelText: 'Lịch hẹn (nếu có)',
                    prefixIcon: const Icon(Icons.calendar_month),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('Không có lịch hẹn')),
                    ...dateAppointments.map((a) => DropdownMenuItem(
                          value: a.id,
                          child: Text(
                              '${a.patientName} - ${a.appointmentTime}',
                              overflow: TextOverflow.ellipsis),
                        )),
                  ],
                  onChanged: (v) {
                    setState(() {
                      _selectedAppointmentId = v;
                      if (v != null) {
                        final apt =
                            provider.appointments.firstWhere((a) => a.id == v);
                        _selectedPatientId = apt.patientId;
                        _selectedPatientName = apt.patientName;
                        if (apt.doctorId != null) {
                          _selectedDoctorId = apt.doctorId;
                          _selectedDoctorName = apt.doctorName;
                        }
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),
                if (provider.doctors.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Chưa có bác sĩ. Vui lòng thêm bác sĩ trước khi tiếp đón.',
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  )
                else
                  DropdownButtonFormField<String>(
                    value: _selectedDoctorId,
                    decoration: InputDecoration(
                      labelText: 'Bác sĩ phụ trách *',
                      prefixIcon: const Icon(Icons.medical_information),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: provider.doctors
                        .map((d) =>
                            DropdownMenuItem(value: d.id, child: Text(d.name)))
                        .toList(),
                    onChanged: (v) => setState(() {
                      _selectedDoctorId = v;
                      _selectedDoctorName =
                          provider.doctors.firstWhere((d) => d.id == v).name;
                    }),
                    validator: (v) => v == null ? 'Vui lòng chọn bác sĩ phụ trách' : null,
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final d = await showDatePicker(
                            context: context,
                            initialDate: _checkinDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2035),
                          );
                          if (d != null) {
                            setState(() {
                              _checkinDate = d;
                              _selectedAppointmentId = null;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Ngày tiếp đón',
                            prefixIcon:
                                const Icon(Icons.calendar_today, size: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                              DateFormat('dd/MM/yyyy').format(_checkinDate)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final t = await showTimePicker(
                              context: context, initialTime: _checkinTime);
                          if (t != null) setState(() => _checkinTime = t);
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Giờ tiếp đón',
                            prefixIcon: const Icon(Icons.access_time, size: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(_formatTime(_checkinTime)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Trạng thái',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        ...[
                          ('waiting', 'Chờ khám'),
                          ('in_progress', 'Đang khám'),
                          ('done', 'Đã xong'),
                          ('cancelled', 'Đã hủy'),
                        ].map((item) => RadioListTile<String>(
                              value: item.$1,
                              groupValue: _status,
                              title: Text(item.$2),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (v) => setState(() => _status = v!),
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Ghi chú',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoading || provider.doctors.isEmpty
                        ? null
                        : _save,
                    child: Text(
                        isEdit ? 'Cập nhật' : 'Thêm phiếu tiếp đón',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    
    // Validate Time (07:00 - 21:00)
    if (_checkinTime.hour < 7 || _checkinTime.hour >= 21) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Giờ tiếp đón không hợp lệ (Phải từ 07:00 đến 21:00)'), backgroundColor: Colors.red));
      return;
    }

    final provider = context.read<AppProvider>();
    
    // Validate duplicate patient on the same day
    if (!isEdit || (isEdit && widget.checkIn!.patientId != _selectedPatientId)) {
      final existingCheckins = provider.getCheckinsByDate(_checkinDate);
      final hasCheckedIn = existingCheckins.any((c) => 
        c.patientId == _selectedPatientId && c.status != 'cancelled' && c.id != widget.checkIn?.id);
      if (hasCheckedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bệnh nhân đã được tiếp đón trong ngày này'), backgroundColor: Colors.red));
        return;
      }
    }

    setState(() => _isLoading = true);
    final now = DateTime.now();

    if (isEdit) {
      provider.updateCheckIn(widget.checkIn!.copyWith(
        checkinCode: _checkinCodeCtrl.text.trim(),
        patientId: _selectedPatientId,
        patientName: _selectedPatientName ?? widget.checkIn!.patientName,
        appointmentId: _selectedAppointmentId,
        doctorId: _selectedDoctorId,
        doctorName: _selectedDoctorName,
        checkinDate: _checkinDate,
        checkinTime: _formatTime(_checkinTime),
        status: _status,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        updatedAt: now,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật phiếu tiếp đón')));
    } else {
      provider.addCheckIn(CheckIn(
        id: now.millisecondsSinceEpoch.toString(),
        checkinCode: _checkinCodeCtrl.text.trim(),
        patientId: _selectedPatientId,
        patientName: _selectedPatientName!,
        appointmentId: _selectedAppointmentId,
        doctorId: _selectedDoctorId!,
        doctorName: _selectedDoctorName!,
        checkinDate: _checkinDate,
        checkinTime: _formatTime(_checkinTime),
        status: _status,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        createdAt: now,
        updatedAt: now,
      ));
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Đã thêm phiếu tiếp đón')));
    }
    Navigator.pop(context);
  }
}
