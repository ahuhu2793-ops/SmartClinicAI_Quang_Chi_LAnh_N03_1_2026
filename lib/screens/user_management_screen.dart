import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import '../theme/app_theme.dart';
import 'user_form_screen.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  String _searchQuery = '';
  String _filterRole = 'all';

  final Map<String, String> _roleLabels = {
    'all': 'Tất cả',
    'admin': 'Quản trị viên',
    'receptionist': 'Lễ tân',
    'doctor': 'Bác sĩ',
    'patient': 'Bệnh nhân',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Thêm người dùng',
            onPressed: () => _navigateToForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm tên, tên đăng nhập, email...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _roleLabels.entries.map((e) {
                final selected = _filterRole == e.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(e.value),
                    selected: selected,
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : null,
                      fontWeight: selected ? FontWeight.bold : null,
                    ),
                    onSelected: (_) => setState(() => _filterRole = e.key),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        var users = auth.allUsers;

        // Filter by role
        if (_filterRole != 'all') {
          users = users.where((u) => u.role == _filterRole).toList();
        }

        // Filter by search
        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          users = users
              .where((u) =>
                  u.name.toLowerCase().contains(q) ||
                  u.username.toLowerCase().contains(q) ||
                  u.email.toLowerCase().contains(q))
              .toList();
        }

        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Không tìm thấy người dùng',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) => _buildUserCard(context, users[index], auth),
        );
      },
    );
  }

  Widget _buildUserCard(BuildContext context, User user, AuthProvider auth) {
    final roleColor = _getRoleColor(user.role);
    final isSelf = auth.currentUser?.id == user.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToForm(user: user),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: roleColor.withOpacity(0.15),
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    color: roleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (isSelf)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Bạn',
                                style: TextStyle(color: Colors.blue, fontSize: 11)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('@${user.username}',
                        style: const TextStyle(
                            color: AppTheme.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: roleColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.roleDisplayName,
                            style: TextStyle(
                                color: roleColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: (user.isActive ? Colors.green : Colors.red)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            user.isActive ? 'Hoạt động' : 'Không hoạt động',
                            style: TextStyle(
                              color: user.isActive ? Colors.green : Colors.red,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isSelf)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (action) => _handleAction(context, action, user, auth),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(user.isActive ? 'Vô hiệu hóa' : 'Kích hoạt'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Xóa', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
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

  void _handleAction(
      BuildContext context, String action, User user, AuthProvider auth) {
    switch (action) {
      case 'edit':
        _navigateToForm(user: user);
        break;
      case 'toggle':
        auth.toggleUserStatus(user.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(user.isActive
                ? 'Đã vô hiệu hóa tài khoản ${user.name}'
                : 'Đã kích hoạt tài khoản ${user.name}'),
          ),
        );
        break;
      case 'delete':
        _confirmDelete(context, user, auth);
        break;
    }
  }

  void _confirmDelete(BuildContext context, User user, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa tài khoản "${user.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await auth.deleteUser(user.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xóa tài khoản ${user.name}')),
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
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToForm({User? user}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserFormScreen(user: user)),
    ).then((_) => setState(() {}));
  }
}
