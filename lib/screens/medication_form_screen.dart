import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/medication.dart';
import '../theme/app_theme.dart';

class MedicationFormScreen extends StatefulWidget {
  final Medication? medication;

  const MedicationFormScreen({Key? key, this.medication}) : super(key: key);

  @override
  State<MedicationFormScreen> createState() => _MedicationFormScreenState();
}

class _MedicationFormScreenState extends State<MedicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late TextEditingController _quantityController;
  late TextEditingController _importPriceController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _notesController;

  DateTime? _expirationDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medication?.name ?? '');
    _unitController = TextEditingController(text: widget.medication?.unit ?? '');
    _quantityController = TextEditingController(text: widget.medication?.quantity.toString() ?? '');
    _importPriceController = TextEditingController(text: widget.medication?.importPrice.toString() ?? '');
    _sellingPriceController = TextEditingController(text: widget.medication?.sellingPrice.toString() ?? '');
    _notesController = TextEditingController(text: widget.medication?.notes ?? '');
    _expirationDate = widget.medication?.expirationDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _quantityController.dispose();
    _importPriceController.dispose();
    _sellingPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication == null ? 'Thêm thuốc' : 'Sửa thuốc'),
        elevation: 0,
        actions: [
          if (widget.medication != null)
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
              label: 'Tên thuốc',
              icon: Icons.medication,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên thuốc';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _unitController,
              label: 'Đơn vị (ví dụ: viên, hộp, lọ)',
              icon: Icons.straighten,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập đơn vị';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _quantityController,
              label: 'Số lượng',
              icon: Icons.inventory,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số lượng';
                }
                final quantity = int.tryParse(value);
                if (quantity == null || quantity < 0) {
                  return 'Vui lòng nhập số lượng hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _importPriceController,
              label: 'Giá nhập (VNĐ)',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập giá nhập';
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
              controller: _sellingPriceController,
              label: 'Giá bán (VNĐ)',
              icon: Icons.sell,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập giá bán';
                }
                final price = double.tryParse(value);
                if (price == null || price <= 0) {
                  return 'Vui lòng nhập giá hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildExpirationDateField(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _notesController,
              label: 'Ghi chú',
              icon: Icons.note,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveMedication,
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

  Widget _buildExpirationDateField() {
    return InkWell(
      onTap: () => _selectExpirationDate(),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Hạn sử dụng',
          prefixIcon: Icon(Icons.event),
        ),
        child: Text(
          _expirationDate != null
              ? DateFormat('dd/MM/yyyy').format(_expirationDate!)
              : 'Chọn hạn sử dụng',
          style: TextStyle(
            color: _expirationDate != null ? null : Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _selectExpirationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && mounted) {
      setState(() {
        _expirationDate = picked;
      });
    }
  }

  void _saveMedication() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);

      final medication = Medication(
        id: widget.medication?.id ?? _uuid.v4(),
        name: _nameController.text.trim(),
        unit: _unitController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        importPrice: double.parse(_importPriceController.text.trim()),
        sellingPrice: double.parse(_sellingPriceController.text.trim()),
        expirationDate: _expirationDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: widget.medication?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.medication == null) {
        provider.addMedication(medication);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm thuốc thành công')),
        );
      } else {
        provider.updateMedication(medication);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật thuốc thành công')),
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
        content: const Text('Bạn có chắc chắn muốn xóa thuốc này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<AppProvider>(context, listen: false);
              provider.deleteMedication(widget.medication!.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa thuốc thành công')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
