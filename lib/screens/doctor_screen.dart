import 'package:flutter/material.dart';
import '../models/doctor.dart';
import '../controllers/list_doctor.dart';

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  final ListDoctor listDoctor = ListDoctor();

  @override
  void initState() {
    super.initState();

    // thêm dữ liệu mẫu
    listDoctor.addDoctor(Doctor(
      id: "d1",
      name: "Dr A",
      email: "a@gmail.com",
      specialization: "Nha khoa",
      salary: 1000,
    ));

    listDoctor.addDoctor(Doctor(
      id: "d2",
      name: "Dr B",
      email: "b@gmail.com",
      specialization: "Chỉnh nha",
      salary: 1200,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách bác sĩ"),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: listDoctor.doctors.length,
        itemBuilder: (context, index) {
          final doctor = listDoctor.doctors[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: Text(doctor.name),
              subtitle: Text(
                  "${doctor.specialization} - ${doctor.email}"),
              trailing: Text("\$${doctor.salary}"),
            ),
          );
        },
      ),
    );
  }
}