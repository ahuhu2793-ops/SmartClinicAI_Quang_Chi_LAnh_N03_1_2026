import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../data/db_helper.dart';

class AuthProvider extends ChangeNotifier {
  final Uuid _uuid = const Uuid();

  User? _currentUser;
  List<User> _users = [];

  Future<void> init() async {
    final list = await DBHelper.instance.queryAll('users');
    if (list.isEmpty) {
      loadDemoUsers();
      for (final user in _users) {
        await DBHelper.instance.insert('users', user.toMap());
      }
    } else {
      _users = list.map((m) => User.fromMap(m)).toList();
      notifyListeners();
    }
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;
  bool get isReceptionist => _currentUser?.isReceptionist ?? false;
  bool get isDoctor => _currentUser?.isDoctor ?? false;
  bool get isPatient => _currentUser?.isPatient ?? false;

  // Admin can manage: Admin OR Receptionist
  bool get canManageUsers => isAdmin;
  // Can register appointments
  bool get canManageAppointments => isAdmin || isReceptionist;
  // Can do checkin
  bool get canCheckin => isAdmin || isReceptionist;
  // Can manage invoices
  bool get canManageInvoices => isAdmin || isReceptionist;
  // Can view statistics
  bool get canViewStatistics => isAdmin;

  List<User> get allUsers => List.unmodifiable(_users);

  List<User> get managedUsers =>
      _users.where((u) => u.id != _currentUser?.id).toList();

  // Load demo users for all roles
  void loadDemoUsers() {
    _users = [
      User(
        id: _uuid.v4(),
        username: 'admin',
        name: 'Quản trị viên',
        email: 'admin@dakhoa.com',
        password: 'admin123',
        phone: '0901234567',
        role: 'admin',
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      User(
        id: _uuid.v4(),
        username: 'letan01',
        name: 'Nguyễn Thị Lan',
        email: 'lan.nguyen@dakhoa.com',
        password: '123456',
        phone: '0912345678',
        role: 'receptionist',
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      User(
        id: _uuid.v4(),
        username: 'bacsi01',
        name: 'BS. Nguyễn Thị Hoa',
        email: 'hoa.nguyen@dakhoa.com',
        password: '123456',
        phone: '0901111111',
        role: 'doctor',
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      User(
        id: _uuid.v4(),
        username: 'bacsi02',
        name: 'BS. Trần Minh Khoa',
        email: 'khoa.tran@dakhoa.com',
        password: '123456',
        phone: '0902222222',
        role: 'doctor',
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      User(
        id: _uuid.v4(),
        username: 'benhnhan01',
        name: 'Nguyễn Văn An',
        email: 'an.nguyen@email.com',
        password: '123456',
        phone: '0923456789',
        role: 'patient',
        status: 'active',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
    notifyListeners();
  }

  // Login by username or email
  Future<bool> login(String usernameOrEmail, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));

    try {
      final user = _users.firstWhere(
        (u) =>
            (u.username.toLowerCase() == usernameOrEmail.toLowerCase() ||
                u.email.toLowerCase() == usernameOrEmail.toLowerCase()) &&
            u.password == password &&
            u.status == 'active',
      );
      _currentUser = user;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // Logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Add user (Admin only)
  Future<bool> addUser({
    required String username,
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
    String status = 'active',
  }) async {
    // 1. Validation checks
    if (username.isEmpty) {
      throw UserValidationException('Username không được để trống');
    }
    final alphanumeric = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!alphanumeric.hasMatch(username)) {
      throw UserValidationException('Username chỉ được phép chứa chữ cái và số');
    }
    if (_users.any((u) => u.username.toLowerCase() == username.toLowerCase())) {
      throw UserValidationException('Username đã tồn tại');
    }
    if (password.length < 6) {
      throw UserValidationException('Mật khẩu không đủ độ dài theo yêu cầu bảo mật');
    }
    final specialChar = RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_=+]');
    if (!specialChar.hasMatch(password)) {
      throw UserValidationException('Mật khẩu chưa đáp ứng yêu cầu bảo mật');
    }
    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        throw UserValidationException('Email không đúng định dạng');
      }
      if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
        throw UserValidationException('Email đã tồn tại');
      }
    }
    if (role.isEmpty) {
      throw UserValidationException('Chưa chọn role');
    }
    final validRoles = {'admin', 'receptionist', 'doctor', 'patient', 'staff'};
    if (!validRoles.contains(role.toLowerCase())) {
      throw UserValidationException('Role không hợp lệ');
    }

    final newUser = User(
      id: _uuid.v4(),
      username: username,
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: role,
      status: status,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _users.add(newUser);
    await DBHelper.instance.insert('users', newUser.toMap());
    notifyListeners();
    return true;
  }

  // Update user
  Future<void> updateUser(User updatedUser) async {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index == -1) {
      throw UserValidationException('Người dùng không tồn tại');
    }
    if (updatedUser.username.isEmpty) {
      throw UserValidationException('Username không được để trống');
    }
    final alphanumeric = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!alphanumeric.hasMatch(updatedUser.username)) {
      throw UserValidationException('Username chỉ được phép chứa chữ cái và số');
    }
    if (_users.any((u) => u.id != updatedUser.id && u.username.toLowerCase() == updatedUser.username.toLowerCase())) {
      throw UserValidationException('Username đã tồn tại');
    }
    if (updatedUser.email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(updatedUser.email)) {
        throw UserValidationException('Email không đúng định dạng');
      }
      if (_users.any((u) => u.id != updatedUser.id && u.email.toLowerCase() == updatedUser.email.toLowerCase())) {
        throw UserValidationException('Email đã tồn tại');
      }
    }
    final validRoles = {'admin', 'receptionist', 'doctor', 'patient', 'staff'};
    if (!validRoles.contains(updatedUser.role.toLowerCase())) {
      throw UserValidationException('Role không hợp lệ');
    }

    final finalUser = updatedUser.copyWith(updatedAt: DateTime.now());
    _users[index] = finalUser;
    if (_currentUser?.id == finalUser.id) {
      _currentUser = finalUser;
    }
    await DBHelper.instance.update('users', finalUser.toMap());
    notifyListeners();
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    final userIdx = _users.indexWhere((u) => u.id == userId);
    if (userIdx == -1) {
      throw UserValidationException('Người dùng không tồn tại');
    }
    final userToDelete = _users[userIdx];
    if (_currentUser?.id == userId) {
      throw UserValidationException('Không thể tự xóa tài khoản của chính mình hoặc tài khoản đang đăng nhập');
    }
    if (userId == '1' || userToDelete.username == 'admin') {
      throw UserValidationException('Không được phép xóa tài khoản Admin chính');
    }
    if (userToDelete.status == 'active') {
      throw UserValidationException('Không thể xóa người dùng đang hoạt động');
    }

    _users.removeAt(userIdx);
    await DBHelper.instance.delete('users', userId);
    notifyListeners();
    return true;
  }

  // Toggle user active/inactive
  Future<void> toggleUserStatus(String userId) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      final user = _users[index];
      final newStatus = user.status == 'active' ? 'inactive' : 'active';
      final finalUser = user.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      _users[index] = finalUser;
      await DBHelper.instance.update('users', finalUser.toMap());
      notifyListeners();
    }
  }

  // Check if username is available
  bool isUsernameAvailable(String username, {String? excludeId}) {
    return !_users.any((u) =>
        u.username.toLowerCase() == username.toLowerCase() &&
        u.id != excludeId);
  }

  // Update current user profile
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (_currentUser != null) {
      final finalUser = _currentUser!.copyWith(
        name: name,
        email: email,
        phone: phone,
        updatedAt: DateTime.now(),
      );
      _currentUser = finalUser;
      await updateUser(finalUser);
    }
  }

  // Change password
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    if (_currentUser?.password == oldPassword) {
      await updateUser(_currentUser!.copyWith(password: newPassword));
      return true;
    }
    return false;
  }

  // Register a new patient user
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // use email local part as username fallback
    final username = email.split('@').first;
    final success = await addUser(
      username: username,
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: 'patient',
      status: 'active',
    );
    if (success) {
      // auto-login the new user
      final loggedIn = await login(email, password);
      return loggedIn;
    }
    return false;
  }
}

class UserValidationException implements Exception {
  final String message;
  UserValidationException(this.message);
  @override
  String toString() => message;
}
