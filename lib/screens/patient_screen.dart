import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../controllers/list_patient.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final ListPatient listPatient = ListPatient();

  @override
  void initState() {
    super.initState();

    listPatient.addPatient(Patient(
      id: "p1",
      name: "Nguyen Van A",
      phone: "0123456789",
      email: "a@gmail.com",
      dateOfBirth: DateTime(2000, 1, 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh sách bệnh nhân")),
      body: ListView.builder(
        itemCount: listPatient.patients.length,
        itemBuilder: (context, index) {
          final p = listPatient.patients[index];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(p.name),
            subtitle: Text("Tuổi: ${p.getAge()}"),
          );
        },
      ),
    );
  }
}