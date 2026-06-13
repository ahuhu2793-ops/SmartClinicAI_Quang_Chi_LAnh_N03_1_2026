import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/patient.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';

class MedicalRecordScreen extends StatefulWidget {
  const MedicalRecordScreen({Key? key}) : super(key: key);

  @override
  State<MedicalRecordScreen> createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen> {
  String? _selectedPatientId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ bệnh án'),
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildPatientDropdown(),
          Expanded(
            child: _buildMedicalRecords(),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientDropdown() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedPatientId,
            decoration: const InputDecoration(
              labelText: 'Chọn bệnh nhân',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
            items: provider.patients.map((patient) {
              return DropdownMenuItem(
                value: patient.id,
                child: Text(patient.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPatientId = value;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildMedicalRecords() {
    if (_selectedPatientId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Vui lòng chọn bệnh nhân để xem hồ sơ',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final patient = provider.patients.firstWhere((p) => p.id == _selectedPatientId);
        final appointments = provider.appointments
            .where((a) => a.patientId == _selectedPatientId)
            .toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildPatientInfoCard(patient),
            const SizedBox(height: 16),
            _buildSectionTitle('Lịch sử khám'),
            const SizedBox(height: 12),
            if (appointments.isEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'Chưa có lịch sử khám',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ),
              )
            else
              ...appointments.map((appointment) => _buildAppointmentCard(appointment)),
          ],
        );
      },
    );
  }

  Widget _buildPatientInfoCard(Patient patient) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.primaryLight,
                  child: Text(
                    patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(patient.phoneNumber),
                      if (patient.dateOfBirth != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Ngày sinh: ${DateFormat('dd/MM/yyyy').format(patient.dateOfBirth!)}',
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (patient.medicalHistory != null && patient.medicalHistory!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Tiền sử bệnh án:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(patient.medicalHistory!),
            ],
            if (patient.notes != null && patient.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Ghi chú:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(patient.notes!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd/MM/yyyy').format(appointment.appointmentDate),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(appointment.appointmentTime),
              ],
            ),
            const SizedBox(height: 8),
            if (appointment.serviceName != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.medical_services,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(appointment.serviceName!),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Icon(
                  Icons.info,
                  color: _getStatusColor(appointment.status),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(appointment.status),
                  style: TextStyle(color: _getStatusColor(appointment.status)),
                ),
              ],
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(appointment.notes!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      case 'in_progress':
        return AppTheme.warningColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Hoàn thành';
      case 'cancelled':
        return 'Đã hủy';
      case 'in_progress':
        return 'Đang khám';
      case 'scheduled':
        return 'Đã đặt';
      default:
        return status;
    }
  }
}
