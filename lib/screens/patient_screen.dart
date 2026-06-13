import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';
import 'patient_form_screen.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({Key? key}) : super(key: key);

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bệnh nhân'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToPatientForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: Consumer<AppProvider>(
              builder: (context, provider, child) {
                List<Patient> filteredPatients = _filterPatients(provider);

                if (filteredPatients.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Không tìm thấy bệnh nhân',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = filteredPatients[index];
                    return _buildPatientCard(context, patient);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm bệnh nhân...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Tất cả', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Đang điều trị', 'active'),
            const SizedBox(width: 8),
            _buildFilterChip('Đã điều trị', 'completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filterStatus = value;
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  List<Patient> _filterPatients(AppProvider provider) {
    List<Patient> patients = provider.patients;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      patients = provider.searchPatients(_searchController.text);
    }

    // Apply status filter
    if (_filterStatus != 'all') {
      patients = patients.where((p) => p.status == _filterStatus).toList();
    }

    return patients;
  }

  Widget _buildPatientCard(BuildContext context, Patient patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToPatientForm(patient: patient),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppTheme.primaryLight,
                    child: Text(
                      patient.name.isNotEmpty ? patient.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          patient.phoneNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(patient.status ?? 'active'),
                ],
              ),
              if (patient.email != null && patient.email!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.email, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      patient.email!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              if (patient.address != null && patient.address!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        patient.address!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'active':
        color = Colors.blue;
        label = 'Đang điều trị';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Đã điều trị';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Đã hủy';
        break;
      default:
        color = Colors.grey;
        label = status;
    }
    
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontSize: 11),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  void _navigateToPatientForm({Patient? patient}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientFormScreen(patient: patient),
      ),
    );
    setState(() {});
  }
}
