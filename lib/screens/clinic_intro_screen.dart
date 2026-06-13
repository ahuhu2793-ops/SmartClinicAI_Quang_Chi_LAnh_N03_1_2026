import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'public_services_screen.dart';
import 'register_screen.dart';

class ClinicIntroScreen extends StatelessWidget {
  const ClinicIntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.local_hospital,
                          color: AppTheme.primaryColor,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Phòng Khám Đa Khoa Smile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hệ thống phòng khám đa khoa chuyên nghiệp',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Giới thiệu'),
                  const SizedBox(height: 16),
                  _buildIntroduction(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Tại sao chọn chúng tôi?'),
                  const SizedBox(height: 16),
                  _buildFeatures(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Giờ mở cửa'),
                  const SizedBox(height: 16),
                  _buildOpeningHours(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Liên hệ'),
                  const SizedBox(height: 16),
                  _buildContactInfo(),
                  const SizedBox(height: 32),
                  _buildActionButtons(context),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildIntroduction() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Chào mừng bạn đến với Phòng Khám Đa Khoa Smile!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Với đội ngũ bác sĩ giàu kinh nghiệm và trang thiết bị hiện đại, chúng tôi cam kết mang lại dịch vụ chăm sóc sức khỏe toàn diện và hiệu quả nhất cho bạn và gia đình.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures() {
    final features = [
      {
        'icon': Icons.verified,
        'title': 'Đội ngũ bác sĩ chuyên nghiệp',
        'description': 'Bác sĩ có nhiều năm kinh nghiệm',
      },
      {
        'icon': Icons.devices,
        'title': 'Trang thiết bị hiện đại',
        'description': 'Công nghệ y khoa tiên tiến',
      },
      {
        'icon': Icons.cleaning_services,
        'title': 'Vệ sinh tuyệt đối',
        'description': 'Tuân thủ quy trình khử khuẩn',
      },
      {
        'icon': 'attach_money',
        'title': 'Giá cả hợp lý',
        'description': 'Chi phí minh bạch, cạnh tranh',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  feature['icon'] is IconData ? feature['icon'] as IconData : Icons.attach_money,
                  color: AppTheme.primaryColor,
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  feature['description'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOpeningHours() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeRow('Thứ 2 - Thứ 6', '08:00 - 18:00'),
            const Divider(),
            _buildTimeRow('Thứ 7', '08:00 - 17:00'),
            const Divider(),
            _buildTimeRow('Chủ nhật', 'Nghỉ'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            time,
            style: TextStyle(
              color: time == 'Nghỉ' ? AppTheme.errorColor : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContactRow(Icons.location_on, 'Địa chỉ', '123 Đường ABC, Quận 1, TP.HCM'),
            const Divider(),
            _buildContactRow(Icons.phone, 'Điện thoại', '0901234567'),
            const Divider(),
            _buildContactRow(Icons.email, 'Email', 'info@dakhoasmile.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelLarge;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          return SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PublicServicesScreen()),
                );
              },
              icon: const Icon(Icons.medical_services),
              label: const Text('Xem dịch vụ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: labelStyle?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PublicServicesScreen()),
                );
              },
              icon: const Icon(Icons.medical_services),
              label: const Text('Xem dịch vụ'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: labelStyle?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Đăng nhập'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: labelStyle?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('Đăng ký tài khoản'),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: labelStyle?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
