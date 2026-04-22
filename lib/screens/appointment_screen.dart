import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../controllers/list_appointment.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final ListAppointment list = ListAppointment();

  @override
  void initState() {
    super.initState();

    list.createAppointment(Appointment(
      id: "a1",
      patientId: "p1",
      doctorId: "d1",
      appointmentDate: DateTime.now().add(const Duration(days: 1)),
      reason: "Khám bệnh định kỳ",
      status: "Pending",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lịch khám")),
      body: ListView.builder(
        itemCount: list.getAllAppointments().length,
        itemBuilder: (context, index) {
          final a = list.getAllAppointments()[index];

          return ListTile(
            leading: const Icon(Icons.calendar_today),
            title: Text("BN: ${a.patientId} - BS: ${a.doctorId}"),
            subtitle: Text("${a.appointmentDate} - ${a.status}"),
          );
        },
      ),
    );
  }
}