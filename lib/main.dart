import 'package:flutter/material.dart';
import 'screens/doctor_screen.dart';
import 'screens/patient_screen.dart';
import 'screens/appointment_screen.dart';


void main() {
  runApp(const ClinicAIApp());
}

class ClinicAIApp extends StatelessWidget {
  const ClinicAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DoctorScreen(),
    );
  }
}