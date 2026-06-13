import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/patient.dart';
import '../theme/app_theme.dart';

class PatientFormScreen extends StatefulWidget {
  final Patient? patient;

  const PatientFormScreen({Key? key, this.patient}) : super(key: key);

  @override
  State<PatientFormScreen> createState() => _PatientFormScreenState();
}

class _PatientFormScreenState extends State<PatientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _medicalHistoryController;
  late TextEditingController _notesController;

  DateTime? _dateOfBirth;
  String? _gender;
  String _status = 'active';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient?.name ?? '');
    _phoneController = TextEditingController(text: widget.patient?.phoneNumber ?? '');
    _emailController = TextEditingController(text: widget.patient?.email ?? '');
    _addressController = TextEditingController(text: widget.patient?.address ?? '');
    _medicalHistoryController = TextEditingController(text: widget.patient?.medicalHistory ?? '');
    _notesController = TextEditingController(text: widget.patient?.notes ?? '');
    _dateOfBirth = widget.patient?.dateOfBirth;
    _gender = widget.patient?.gender;
    _status = widget.patient?.status ?? 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _medicalHistoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient == null ? 'Thêm bệnh nhân' : 'Sửa bệnh nhân'),
        elevation: 0,
        actions: [
          if (widget.patient != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(
              controller: _nameController,
              label: 'Họ và tên',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập họ tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Số điện thoại',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildDateOfBirthField(),
            const SizedBox(height: 16),
            _buildGenderField(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _addressController,
              label: 'Địa chỉ',
              icon: Icons.location_on,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _medicalHistoryController,
              label: 'Tiền sử bệnh án',
              icon: Icons.history,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _notesController,
              label: 'Ghi chú',
              icon: Icons.note,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildStatusField(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _savePatient,
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
    );
  }

  Widget _buildDateOfBirthField() {
    return InkWell(
      onTap: () => _selectDateOfBirth(),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Ngày sinh',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          _dateOfBirth != null
              ? DateFormat('dd/MM/yyyy').format(_dateOfBirth!)
              : 'Chọn ngày sinh',
          style: TextStyle(
            color: _dateOfBirth != null ? null : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Giới tính',
        prefixIcon: Icon(Icons.wc),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _gender,
          hint: const Text('Chọn giới tính'),
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'Nam', child: Text('Nam')),
            DropdownMenuItem(value: 'Nữ', child: Text('Nữ')),
            DropdownMenuItem(value: 'Khác', child: Text('Khác')),
          ],
          onChanged: (value) {
            setState(() {
              _gender = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildStatusField() {
    return InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Trạng thái',
        prefixIcon: Icon(Icons.info),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _status,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'active', child: Text('Đang điều trị')),
            DropdownMenuItem(value: 'completed', child: Text('Đã điều trị')),
            DropdownMenuItem(value: 'cancelled', child: Text('Đã hủy')),
          ],
          onChanged: (value) {
            setState(() {
              _status = value ?? 'active';
            });
          },
        ),
      ),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _savePatient() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      final patient = Patient(
        id: widget.patient?.id ?? _uuid.v4(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        dateOfBirth: _dateOfBirth,
        gender: _gender,
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        medicalHistory: _medicalHistoryController.text.trim().isEmpty ? null : _medicalHistoryController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        status: _status,
        createdAt: widget.patient?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.patient == null) {
        provider.addPatient(patient);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm bệnh nhân thành công')),
        );
      } else {
        provider.updatePatient(patient);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật bệnh nhân thành công')),
        );
      }

      Navigator.pop(context);
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa bệnh nhân này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<AppProvider>(context, listen: false);
              provider.deletePatient(widget.patient!.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa bệnh nhân thành công')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
