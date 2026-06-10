import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/service.dart';
import '../theme/app_theme.dart';

class ServiceFormScreen extends StatefulWidget {
  final Service? service;

  const ServiceFormScreen({Key? key, this.service}) : super(key: key);

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;

  String _status = 'active';

  @override
  void initState() {
    super.initState();
    _codeController =
        TextEditingController(text: widget.service?.serviceCode ?? '');
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _priceController =
        TextEditingController(text: widget.service?.price.toString() ?? '');
    _descriptionController =
        TextEditingController(text: widget.service?.description ?? '');
    _durationController =
        TextEditingController(text: widget.service?.duration?.toString() ?? '');
    _status = widget.service?.status ?? 'active';

    if (widget.service == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _codeController.text.isEmpty) {
          final provider = context.read<AppProvider>();
          _codeController.text = provider.generateServiceCode();
        }
      });
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service == null ? 'Thêm dịch vụ' : 'Sửa dịch vụ'),
        elevation: 0,
        actions: [
          if (widget.service != null)
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
              label: 'Mã dịch vụ',
              icon: Icons.qr_code,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập mã dịch vụ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _nameController,
              label: 'Tên dịch vụ',
              icon: Icons.medical_services,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên dịch vụ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _priceController,
              label: 'Giá (VNĐ)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập giá';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'Vui lòng nhập giá hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _durationController,
              label: 'Thời gian thực hiện (phút)',
              icon: Icons.access_time,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _descriptionController,
              label: 'Mô tả',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Trạng thái',
                prefixIcon: Icon(Icons.info_outline),
              ),
              items: const [
                DropdownMenuItem(
                    value: 'active', child: Text('Đang hoạt động')),
                DropdownMenuItem(
                    value: 'suspended', child: Text('Tạm dừng')),
                DropdownMenuItem(
                    value: 'inactive', child: Text('Ngừng hoạt động')),
              ],
              onChanged: (value) {
                setState(() => _status = value ?? 'active');
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveService,
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

  void _saveService() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);

      final service = Service(
        id: widget.service?.id ?? _uuid.v4(),
        serviceCode: _codeController.text.trim(),
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        duration: _durationController.text.trim().isEmpty
            ? null
            : int.tryParse(_durationController.text.trim()),
        status: _status,
        createdAt: widget.service?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        if (widget.service == null) {
          await provider.addService(service);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã thêm dịch vụ thành công')),
            );
            Navigator.pop(context);
          }
        } else {
          await provider.updateService(service);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đã cập nhật dịch vụ thành công')),
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
        content: const Text('Bạn có chắc chắn muốn xóa dịch vụ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              final provider = Provider.of<AppProvider>(context, listen: false);
              try {
                await provider.deleteService(widget.service!.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã xóa dịch vụ thành công')),
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
            child: const Text('Xóa', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
