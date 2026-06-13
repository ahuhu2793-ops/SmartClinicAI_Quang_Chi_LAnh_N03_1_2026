import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildLogo(),
                const SizedBox(height: 24),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildSubtitle(),
                const SizedBox(height: 32),
                _buildNameField(),
                const SizedBox(height: 16),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPhoneField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 16),
                _buildConfirmPasswordField(),
                const SizedBox(height: 24),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.local_hospital,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Tạo tài khoản mới',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return const Text(
      'Đăng ký để đặt lịch và xem hồ sơ bệnh án',
      style: TextStyle(
        fontSize: 14,
        color: AppTheme.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Họ và tên',
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập họ tên';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập email';
        }
        if (!value.contains('@')) {
          return 'Email không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Số điện thoại',
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        if (value.length < 10) {
          return 'Số điện thoại không hợp lệ';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      obscureText: _obscurePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng nhập mật khẩu';
        }
        if (value.length < 6) {
          return 'Mật khẩu phải có ít nhất 6 ký tự';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        labelText: 'Xác nhận mật khẩu',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ),
      obscureText: _obscureConfirmPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Vui lòng xác nhận mật khẩu';
        }
        if (value != _passwordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleRegister,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Đăng ký',
              style: TextStyle(fontSize: 16),
            ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email đã được sử dụng'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}
