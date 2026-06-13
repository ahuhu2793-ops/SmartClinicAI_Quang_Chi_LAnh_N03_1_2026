import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Thông tin phòng khám'),
          const SizedBox(height: 16),
          _buildClinicInfoCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Cài đặt chung'),
          const SizedBox(height: 16),
          _buildGeneralSettings(),
          const SizedBox(height: 24),
          _buildSectionTitle('Thông báo'),
          const SizedBox(height: 16),
          _buildNotificationSettings(),
          const SizedBox(height: 24),
          _buildSectionTitle('Khác'),
          const SizedBox(height: 16),
          _buildOtherSettings(),
          const SizedBox(height: 24),
          _buildAppInfo(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildClinicInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_hospital,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phòng Khám Đa Khoa Smile',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '123 Đường ABC, Quận 1, TP.HCM',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.phone, '0901234567'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, 'info@dakhoasmile.com'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, 'Thứ 2 - Thứ 7: 8:00 - 18:00'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Ngôn ngữ'),
            subtitle: const Text('Tiếng Việt'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Chế độ tối'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Cỡ chữ'),
            subtitle: const Text('Trung bình'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Thông báo đẩy'),
            trailing: Switch(
              value: true,
              onChanged: (value) {},
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Thông báo email'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Nhắc lịch hẹn'),
            subtitle: const Text('Nhắc trước 1 ngày'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOtherSettings() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Sao lưu dữ liệu'),
            subtitle: const Text('Lần sao lưu cuối: Hôm nay'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Khôi phục dữ liệu'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Bảo mật'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Trợ giúp & Hỗ trợ'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Về ứng dụng'),
            subtitle: const Text('Phiên bản 1.0.0'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: AppTheme.errorColor),
            title: const Text('Đăng xuất', style: TextStyle(color: AppTheme.errorColor)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Xác nhận đăng xuất'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle logout
                      },
                      child: const Text('Đăng xuất', style: TextStyle(color: AppTheme.errorColor)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
