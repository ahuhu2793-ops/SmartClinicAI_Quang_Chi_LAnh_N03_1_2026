import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';

class UserFormScreen extends StatefulWidget {
  final User? user;
  const UserFormScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String _role = 'patient';
  String _status = 'active';
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  bool get isEdit => widget.user != null;

  final Map<String, String> _roleLabels = {
    'admin': 'Quản trị viên',
    'receptionist': 'Lễ tân',
    'doctor': 'Bác sĩ',
    'patient': 'Bệnh nhân',
  };

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final u = widget.user!;
      _usernameCtrl.text = u.username;
      _nameCtrl.text = u.name;
      _emailCtrl.text = u.email;
      _phoneCtrl.text = u.phone;
      _role = u.role;
      _status = u.status;
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Chỉnh sửa người dùng' : 'Thêm người dùng'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionTitle('Thông tin đăng nhập'),
            const SizedBox(height: 12),
            _buildField(
              controller: _usernameCtrl,
              label: 'Tên đăng nhập *',
              icon: Icons.person_outline,
              enabled: !isEdit,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Vui lòng nhập tên đăng nhập';
                if (v.trim().length < 4) return 'Tối thiểu 4 ký tự';
                return null;
              },
            ),
            const SizedBox(height: 12),
            if (!isEdit) ...[
              _buildField(
                controller: _passwordCtrl,
                label: 'Mật khẩu *',
                icon: Icons.lock_outline,
                obscure: _obscurePass,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
                  if (v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildField(
                controller: _confirmCtrl,
                label: 'Xác nhận mật khẩu *',
                icon: Icons.lock_outline,
                obscure: _obscureConfirm,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Vui lòng xác nhận mật khẩu';
                  if (v != _passwordCtrl.text) return 'Mật khẩu không khớp';
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],
            _buildSectionTitle('Thông tin cá nhân'),
            const SizedBox(height: 12),
            _buildField(
              controller: _nameCtrl,
              label: 'Họ và tên *',
              icon: Icons.badge_outlined,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _emailCtrl,
              label: 'Email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _phoneCtrl,
              label: 'Số điện thoại',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildSectionTitle('Phân quyền & Trạng thái'),
            const SizedBox(height: 12),
            // Role selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Vai trò *',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    ..._roleLabels.entries.map((e) {
                      final color = _getRoleColor(e.key);
                      return RadioListTile<String>(
                        value: e.key,
                        groupValue: _role,
                        title: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: color, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Text(e.value),
                          ],
                        ),
                        activeColor: AppTheme.primaryColor,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        onChanged: (v) => setState(() => _role = v!),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Status selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Trạng thái *',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'active',
                            groupValue: _status,
                            title: const Text('Hoạt động'),
                            activeColor: Colors.green,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onChanged: (v) => setState(() => _status = v!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            value: 'inactive',
                            groupValue: _status,
                            title: const Text('Không HĐ'),
                            activeColor: Colors.red,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            onChanged: (v) => setState(() => _status = v!),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isLoading ? null : _save,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isEdit ? 'Cập nhật' : 'Thêm người dùng',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor));
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[100],
      ),
      validator: validator,
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.orange;
      case 'receptionist':
        return Colors.blue;
      case 'doctor':
        return AppTheme.primaryColor;
      case 'patient':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final auth = context.read<AuthProvider>();

    try {
      if (isEdit) {
        await auth.updateUser(widget.user!.copyWith(
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          role: _role,
          status: _status,
        ));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật thành công')));
          Navigator.pop(context);
        }
      } else {
        final success = await auth.addUser(
          username: _usernameCtrl.text.trim(),
          name: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
          phone: _phoneCtrl.text.trim(),
          role: _role,
          status: _status,
        );
        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Thêm người dùng thành công')));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Tên đăng nhập hoặc email đã tồn tại'),
                backgroundColor: Colors.red));
          }
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
