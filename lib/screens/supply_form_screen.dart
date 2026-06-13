import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/app_provider.dart';
import '../models/supply.dart';
import '../theme/app_theme.dart';

class SupplyFormScreen extends StatefulWidget {
  final Supply? supply;

  const SupplyFormScreen({Key? key, this.supply}) : super(key: key);

  @override
  State<SupplyFormScreen> createState() => _SupplyFormScreenState();
}

class _SupplyFormScreenState extends State<SupplyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late TextEditingController _quantityController;
  late TextEditingController _importPriceController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.supply?.name ?? '');
    _unitController = TextEditingController(text: widget.supply?.unit ?? '');
    _quantityController = TextEditingController(text: widget.supply?.quantity.toString() ?? '');
    _importPriceController = TextEditingController(text: widget.supply?.importPrice.toString() ?? '');
    _notesController = TextEditingController(text: widget.supply?.notes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _quantityController.dispose();
    _importPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supply == null ? 'Thêm vật tư' : 'Sửa vật tư'),
        elevation: 0,
        actions: [
          if (widget.supply != null)
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
              label: 'Tên vật tư',
              icon: Icons.inventory_2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên vật tư';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _unitController,
              label: 'Đơn vị (ví dụ: hộp, gói, cái)',
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
              controller: _notesController,
              label: 'Ghi chú',
              icon: Icons.note,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSupply,
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

  void _saveSupply() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);

      final supply = Supply(
        id: widget.supply?.id ?? _uuid.v4(),
        name: _nameController.text.trim(),
        unit: _unitController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        importPrice: double.parse(_importPriceController.text.trim()),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: widget.supply?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.supply == null) {
        provider.addSupply(supply);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã thêm vật tư thành công')),
        );
      } else {
        provider.updateSupply(supply);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật vật tư thành công')),
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
        content: const Text('Bạn có chắc chắn muốn xóa vật tư này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final provider = Provider.of<AppProvider>(context, listen: false);
              provider.deleteSupply(widget.supply!.id);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa vật tư thành công')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }
}
