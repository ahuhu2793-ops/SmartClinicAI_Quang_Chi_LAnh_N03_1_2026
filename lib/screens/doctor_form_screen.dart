import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/doctor.dart';
import '../theme/app_theme.dart';

class DoctorFormScreen extends StatefulWidget {
  final Doctor? doctor;

  const DoctorFormScreen({Key? key, this.doctor}) : super(key: key);

  @override
  State<DoctorFormScreen> createState() => _DoctorFormScreenState();
}

class _DoctorFormScreenState extends State<DoctorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _emailController;
  late TextEditingController _salaryController;
  late TextEditingController _workplaceController;
  late TextEditingController _degreeController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;

  DateTime? _dateOfBirth;

  @override
  void initState() {
    super.initState();
    _codeController =
        TextEditingController(text: widget.doctor?.doctorCode ?? '');
    _nameController =
        TextEditingController(text: widget.doctor?.name ?? '');
    _specializationController =
        TextEditingController(text: widget.doctor?.specialization ?? '');
    _emailController =
        TextEditingController(text: widget.doctor?.email ?? '');
    _salaryController = TextEditingController(
        text: widget.doctor?.salary.toStringAsFixed(0) ?? '');
    _workplaceController =
        TextEditingController(text: widget.doctor?.workplace ?? '');
    _degreeController =
        TextEditingController(text: widget.doctor?.degree ?? '');
    _phoneController =
        TextEditingController(text: widget.doctor?.phoneNumber ?? '');
    _notesController =
        TextEditingController(text: widget.doctor?.notes ?? '');
    _dateOfBirth = widget.doctor?.dateOfBirth;

    if (widget.doctor == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _codeController.text.isEmpty) {
          final provider = context.read<AppProvider>();
          _codeController.text = provider.generateDoctorCode();
        }
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _specializationController.dispose();
    _emailController.dispose();
    _salaryController.dispose();
    _workplaceController.dispose();
    _degreeController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.doctor != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Sửa bác sĩ' : 'Thêm bác sĩ'),
        elevation: 0,
        actions: [
          if (isEditing)
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
              controller: _codeController,
              label: 'Mã số bác sĩ',
              icon: Icons.badge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập mã số bác sĩ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: 'Họ và tên bác sĩ',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập họ tên bác sĩ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _dateOfBirth ?? DateTime(1990, 1, 1),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (d != null) setState(() => _dateOfBirth = d);
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Ngày sinh',
                  prefixIcon: Icon(Icons.cake),
                ),
                child: Text(
                  _dateOfBirth != null
                      ? DateFormat('dd/MM/yyyy').format(_dateOfBirth!)
                      : 'Chọn ngày sinh',
                  style: TextStyle(
                    color: _dateOfBirth != null ? null : Colors.grey[600],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _specializationController,
              label: 'Chuyên môn',
              icon: Icons.medical_information,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập chuyên môn';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _workplaceController,
              label: 'Nơi công tác',
              icon: Icons.business,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _degreeController,
              label: 'Bằng cấp / Học hàm học vị',
              icon: Icons.school,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value.trim())) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _salaryController,
              label: 'Lương (VNĐ)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập lương';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Lương phải là số hợp lệ';
                }
                if (double.parse(value.trim()) < 0) {
                  return 'Lương không được âm';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _phoneController,
              label: 'Số điện thoại (tuỳ chọn)',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _notesController,
              label: 'Ghi chú (tuỳ chọn)',
              icon: Icons.note,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveDoctor,
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? 'Cập nhật' : 'Thêm bác sĩ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
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

  void _saveDoctor() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);

      final doctor = Doctor(
        id: widget.doctor?.id ?? _uuid.v4(),
        doctorCode: _codeController.text.trim(),
        name: _nameController.text.trim(),
        specialization: _specializationController.text.trim(),
        email: _emailController.text.trim(),
        salary: double.parse(_salaryController.text.trim()),
        dateOfBirth: _dateOfBirth,
        workplace: _workplaceController.text.trim().isEmpty
            ? null
            : _workplaceController.text.trim(),
        degree: _degreeController.text.trim().isEmpty
            ? null
            : _degreeController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: widget.doctor?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        if (widget.doctor == null) {
          await provider.addDoctor(doctor);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã thêm bác sĩ thành công')),
            );
            Navigator.pop(context);
          }
        } else {
          await provider.updateDoctor(doctor);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật bác sĩ thành công')),
            );
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
            'Bạn có chắc chắn muốn xóa bác sĩ "${widget.doctor!.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              final provider =
                  Provider.of<AppProvider>(context, listen: false);
              try {
                await provider.deleteDoctor(widget.doctor!.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa bác sĩ thành công')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Xóa',
                style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
