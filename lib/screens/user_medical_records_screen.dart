import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../models/patient.dart';
import '../models/user.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'appointment_form_screen.dart';

class UserMedicalRecordsScreen extends StatefulWidget {
  const UserMedicalRecordsScreen({Key? key}) : super(key: key);

  @override
  State<UserMedicalRecordsScreen> createState() => _UserMedicalRecordsScreenState();
}

class _UserMedicalRecordsScreenState extends State<UserMedicalRecordsScreen> {
  bool _isResolving = true;

  @override
  void initState() {
    super.initState();
    _resolvePatient();
  }

  void _resolvePatient() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final appProvider = Provider.of<AppProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null && user.isPatient) {
        Patient? patient;
        if (user.patientId != null) {
          try {
            patient = appProvider.patients.firstWhere((p) => p.id == user.patientId);
          } catch (_) {}
        }

        if (patient == null) {
          try {
            patient = appProvider.patients.firstWhere(
              (p) => p.phoneNumber == user.phone || (p.email != null && p.email == user.email),
            );
            user.patientId = patient.id;
            await authProvider.updateUser(user);
          } catch (_) {
            patient = Patient(
              id: const Uuid().v4(),
              name: user.name,
              phoneNumber: user.phone,
              email: user.email.isNotEmpty ? user.email : null,
              status: 'active',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            await appProvider.addPatient(patient);
            user.patientId = patient.id;
            await authProvider.updateUser(user);
          }
        }
      }

      if (mounted) {
        setState(() {
          _isResolving = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, AppProvider>(
      builder: (context, authProvider, appProvider, child) {
        final user = authProvider.currentUser;
        
        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Hồ sơ bệnh án của tôi'),
              elevation: 0,
            ),
            body: const Center(
              child: Text('Vui lòng đăng nhập'),
            ),
          );
        }

        if (_isResolving) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Hồ sơ bệnh án của tôi'),
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Find patient linked to user
        final patient = user.patientId != null
            ? appProvider.patients.firstWhere(
                (p) => p.id == user.patientId,
                orElse: () => appProvider.patients.first,
              )
            : null;

        if (patient == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Hồ sơ bệnh án của tôi'),
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có hồ sơ bệnh án',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng liên hệ phòng khám để tạo hồ sơ')),
                      );
                    },
                    child: const Text('Liên hệ phòng khám'),
                  ),
                ],
              ),
            ),
          );
        }

        final appointments = appProvider.appointments
            .where((a) => a.patientId == patient.id)
            .toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hồ sơ bệnh án của tôi'),
            elevation: 0,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildPatientInfoCard(patient, user),
              const SizedBox(height: 16),
              _buildSectionTitle('Lịch sử khám'),
              const SizedBox(height: 12),
              if (appointments.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Chưa có lịch sử khám',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AppointmentFormScreen(
                                  appointment: null,
                                  preSelectedPatientId: patient.id,
                                ),
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Đặt lịch khám'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...appointments.map((appointment) => _buildAppointmentCard(appointment)),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppointmentFormScreen(
                    appointment: null,
                    preSelectedPatientId: patient.id,
                  ),
                ),
              ).then((_) {
                setState(() {});
              });
            },
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            label: const Text('Đặt lịch khám', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildPatientInfoCard(Patient patient, User user) {
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
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
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
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(user.phone),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
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
