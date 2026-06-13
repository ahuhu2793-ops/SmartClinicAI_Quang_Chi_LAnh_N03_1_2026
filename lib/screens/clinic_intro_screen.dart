import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'public_services_screen.dart';
import 'register_screen.dart';
import 'appointment_form_screen.dart';
import 'doctor_screen.dart';
import 'patient_screen.dart';
import 'medical_record_list_screen.dart';
import 'medication_screen.dart';
import 'supply_screen.dart';
import 'invoice_screen.dart';
import 'user_medical_records_screen.dart';

class ClinicIntroScreen extends StatefulWidget {
  const ClinicIntroScreen({Key? key}) : super(key: key);

  @override
  State<ClinicIntroScreen> createState() => _ClinicIntroScreenState();
}

class _ClinicIntroScreenState extends State<ClinicIntroScreen> {
  int _currentTab = 0;
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _checkAuthAndNavigate(Widget destinationScreen) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destinationScreen),
      );
    } else {
      _showLoginPromptDialog();
    }
  }

  void _showLoginPromptDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: AppTheme.primaryColor),
            SizedBox(width: 8),
            Text('Yêu cầu đăng nhập'),
          ],
        ),
        content: const Text('Bạn cần đăng nhập tài khoản để sử dụng chức năng này. Bạn có muốn đăng nhập ngay không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    // Filter services or doctors based on search
    final filteredServices = appProvider.services
        .where((s) => s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      s.serviceCode.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final filteredDoctors = appProvider.doctors
        .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      d.specialization.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: _buildTabBody(authProvider, appProvider, filteredServices, filteredDoctors),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                _checkAuthAndNavigate(const AppointmentFormScreen());
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Đặt lịch ngay'),
              backgroundColor: AppTheme.successColor,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (index) {
          setState(() {
            _currentTab = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Thanh toán',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Lịch hẹn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Hỗ trợ',
          ),
        ],
      ),
    );
  }

  Widget _buildTabBody(
    AuthProvider authProvider,
    AppProvider appProvider,
    List<dynamic> filteredServices,
    List<dynamic> filteredDoctors,
  ) {
    switch (_currentTab) {
      case 0:
        return _buildHomeTab(authProvider, appProvider, filteredServices, filteredDoctors);
      case 1:
        return const PublicServicesScreen();
      case 2:
        return authProvider.isAuthenticated
            ? const InvoiceScreen()
            : _buildLoginPlaceholder('Xem hóa đơn & thanh toán');
      case 3:
        return authProvider.isAuthenticated
            ? UserMedicalRecordsScreen()
            : _buildLoginPlaceholder('Theo dõi hồ sơ & lịch hẹn');
      case 4:
        return _buildSupportTab();
      default:
        return const Center(child: Text('Trang không tồn tại'));
    }
  }

  Widget _buildLoginPlaceholder(String featureName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: AppTheme.primaryLight),
            const SizedBox(height: 24),
            Text(
              'Yêu cầu đăng nhập',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Vui lòng đăng nhập để sử dụng tính năng:\n"$featureName"',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppTheme.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Đăng nhập ngay', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Chưa có tài khoản? Đăng ký ngay'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeTab(
    AuthProvider authProvider,
    AppProvider appProvider,
    List<dynamic> filteredServices,
    List<dynamic> filteredDoctors,
  ) {
    return Column(
      children: [
        _buildGrabHeader(authProvider),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await appProvider.init();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                if (_searchQuery.isNotEmpty)
                  _buildSearchResults(filteredServices, filteredDoctors)
                else ...[
                  _buildWelcomeBanner(),
                  _buildServiceGrid(),
                  _buildStatusCard(),
                  _buildPromotionsSection(),
                  _buildIntroSection(),
                  _buildOpeningHoursSection(),
                  _buildContactSection(),
                  const SizedBox(height: 32),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrabHeader(AuthProvider authProvider) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primaryColor, AppTheme.primaryLight],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      child: Row(
        children: [
          // Left QR scanner icon
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('QR Code Check-in'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.qr_code_2, size: 120, color: AppTheme.primaryColor),
                      SizedBox(height: 16),
                      Text(
                        'Đưa mã QR Check-in của bạn hoặc quét mã tại quầy tiếp đón của Smile Clinic để xác nhận thông tin nhanh chóng.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Đóng'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          // Search input bar
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm dịch vụ, bác sĩ...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        filled: false,
                      ),
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _searchCtrl.clear();
                          _searchQuery = "";
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // User avatar or login button
          authProvider.isAuthenticated
              ? InkWell(
                  onTap: () {
                    setState(() {
                      _currentTab = 4; // Navigate to account/support info
                    });
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Text(
                      authProvider.currentUser?.name.isNotEmpty == true
                          ? authProvider.currentUser!.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phòng Khám Đa Khoa Smile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Hệ thống phòng khám đa khoa chuyên nghiệp',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceGrid() {
    final gridItems = [
      {
        'icon': Icons.calendar_today,
        'label': 'Đặt lịch khám',
        'color': Colors.green,
        'action': () => _checkAuthAndNavigate(const AppointmentFormScreen()),
      },
      {
        'icon': Icons.medical_services,
        'label': 'Dịch vụ',
        'color': Colors.blue,
        'action': () {
          setState(() {
            _currentTab = 1; // Services view
          });
        },
      },
      {
        'icon': Icons.people_alt,
        'label': 'Bác sĩ',
        'color': Colors.teal,
        'action': () => _checkAuthAndNavigate(const DoctorScreen()),
      },
      {
        'icon': Icons.folder_shared,
        'label': 'Bệnh án',
        'color': Colors.orange,
        'action': () => _checkAuthAndNavigate(UserMedicalRecordsScreen()),
      },
      {
        'icon': Icons.medication,
        'label': 'Kho thuốc',
        'color': Colors.redAccent,
        'action': () => _checkAuthAndNavigate(const MedicationScreen()),
      },
      {
        'icon': Icons.healing,
        'label': 'Vật tư',
        'color': Colors.purple,
        'action': () => _checkAuthAndNavigate(const SupplyScreen()),
      },
      {
        'icon': Icons.access_time,
        'label': 'Giờ mở cửa',
        'color': Colors.amber,
        'action': () => _showOpeningHoursBottomSheet(),
      },
      {
        'icon': Icons.phone,
        'label': 'Liên hệ',
        'color': Colors.indigo,
        'action': () => _showContactBottomSheet(),
      },
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: gridItems.length,
        itemBuilder: (context, index) {
          final item = gridItems[index];
          return InkWell(
            onTap: item['action'] as VoidCallback,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: item['color'] as Color,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['label'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: Colors.white,
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.health_and_safety, color: AppTheme.primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tình trạng hoạt động',
                      style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Smile Clinic: Đang mở cửa',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.successColor),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Thông tin phòng khám'),
                      content: const Text(
                        'Phòng khám Đa khoa Smile sẵn sàng đón tiếp bệnh nhân từ 08:00 đến 18:00 hàng ngày. Đội ngũ bác sĩ và nhân viên túc trực để phục vụ chu đáo nhất.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đồng ý'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Chi tiết',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionsSection() {
    final promos = [
      {
        'title': 'Gói Khám Tổng Quát',
        'subtitle': 'Giảm giá 20% tháng này',
        'desc': 'Chăm sóc sức khỏe toàn diện với đầy đủ danh mục xét nghiệm & chẩn đoán hình ảnh.',
        'gradient': [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
        'icon': Icons.spa,
        'iconColor': Colors.green.shade700,
      },
      {
        'title': 'Chuyên Khoa Nhi',
        'subtitle': 'Miễn phí tư vấn dinh dưỡng',
        'desc': 'Bác sĩ nhi khoa nhiệt tình, ân cần chăm sóc trẻ nhỏ bằng tất cả sự thấu hiểu.',
        'gradient': [const Color(0xFFE0F7FA), const Color(0xFFB2EBF2)],
        'icon': Icons.child_care,
        'iconColor': Colors.cyan.shade700,
      },
      {
        'title': 'Khám Sức Khỏe Doanh Nghiệp',
        'subtitle': 'Hợp đồng linh hoạt',
        'desc': 'Đảm bảo sức khỏe cho tập thể cán bộ nhân viên với gói khám định kỳ chất lượng cao.',
        'gradient': [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
        'icon': Icons.business,
        'iconColor': Colors.orange.shade700,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Tin tức & Ưu đãi y khoa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: promos.length,
            itemBuilder: (context, index) {
              final promo = promos[index];
              return Container(
                width: 290,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Card(
                  elevation: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: promo['gradient'] as List<Color>,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                promo['title'] as String,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                promo['subtitle'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: promo['iconColor'] as Color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Text(
                                  promo['desc'] as String,
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade800, height: 1.4),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          promo['icon'] as IconData,
                          size: 44,
                          color: (promo['iconColor'] as Color).withOpacity(0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSearchResults(List<dynamic> services, List<dynamic> doctors) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kết quả tìm kiếm cho: "${_searchQuery}"',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (services.isEmpty && doctors.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Text('Không tìm thấy dịch vụ hoặc bác sĩ nào phù hợp.'),
              ),
            ),
          if (services.isNotEmpty) ...[
            const Text('Dịch vụ phòng khám', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, idx) {
                final s = services[idx];
                return ListTile(
                  leading: const Icon(Icons.medical_services, color: AppTheme.primaryLight),
                  title: Text(s.name),
                  subtitle: Text('Mã: ${s.serviceCode} - Giá: ${s.price != null ? "${s.price} VND" : "Liên hệ"}'),
                  onTap: () {
                    setState(() {
                      _searchCtrl.clear();
                      _searchQuery = "";
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PublicServicesScreen()),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          if (doctors.isNotEmpty) ...[
            const Text('Đội ngũ bác sĩ', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: doctors.length,
              itemBuilder: (context, idx) {
                final d = doctors[idx];
                return ListTile(
                  leading: const Icon(Icons.people_alt, color: AppTheme.primaryLight),
                  title: Text(d.name),
                  subtitle: Text('Chuyên khoa: ${d.specialization} - Học vị: ${d.degree ?? "Bác sĩ"}'),
                  onTap: () {
                    setState(() {
                      _searchCtrl.clear();
                      _searchQuery = "";
                    });
                    _checkAuthAndNavigate(const DoctorScreen());
                  },
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giới thiệu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Chào mừng bạn đến với Phòng Khám Đa Khoa Smile!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
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
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningHoursSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giờ mở cửa',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTimeRow('Thứ 2 - Thứ 6', '08:00 - 18:00'),
                  const Divider(),
                  _buildTimeRow('Thứ 7', '08:00 - 17:00'),
                  const Divider(),
                  _buildTimeRow('Chủ nhật', 'Nghỉ'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: time == 'Nghỉ' ? AppTheme.errorColor : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Liên hệ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 12),
          Card(
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
          ),
        ],
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
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTab() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hỗ trợ & Hướng dẫn'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: Column(
              children: [
                Icon(Icons.help_center_outlined, size: 64, color: AppTheme.primaryColor),
                SizedBox(height: 12),
                Text(
                  'Trung tâm trợ giúp Smile Clinic',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Giải đáp nhanh thắc mắc của bạn',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Câu hỏi thường gặp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          const SizedBox(height: 12),
          _buildFAQItem('Làm thế nào để đăng ký đặt lịch hẹn trước?', 'Bạn có thể ấn nút "Đặt lịch ngay" ở Trang chủ hoặc vào mục "Lịch hẹn" để đặt ngày giờ khám, chuyên khoa và bác sĩ mong muốn.'),
          _buildFAQItem('Tôi có thể xem lại hồ sơ bệnh án cũ của mình không?', 'Có, sau khi bạn đăng nhập tài khoản bệnh nhân, hãy vào tab "Lịch hẹn / Hồ sơ bệnh án" để tra cứu bệnh sử cũ cùng đơn thuốc.'),
          _buildFAQItem('Chi phí các gói khám được niêm yết thế nào?', 'Bạn có thể xem đầy đủ tại tab "Khám phá" để tra cứu giá dịch vụ khám bệnh công khai.'),
          const SizedBox(height: 24),
          const Text('Tài khoản của bạn', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          const SizedBox(height: 12),
          auth.isAuthenticated
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tên bệnh nhân: ${auth.currentUser?.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Email đăng ký: ${auth.currentUser?.email}'),
                        const SizedBox(height: 8),
                        Text('Số điện thoại: ${auth.currentUser?.phone ?? "Chưa cập nhật"}'),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              auth.logout();
                              setState(() {
                                _currentTab = 0;
                              });
                            },
                            icon: const Icon(Icons.logout, color: AppTheme.errorColor),
                            label: const Text('Đăng xuất', style: TextStyle(color: AppTheme.errorColor)),
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.errorColor)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bạn hiện đang truy cập dưới vai trò Khách.', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                                child: const Text('Đăng nhập', style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                                  );
                                },
                                child: const Text('Đăng ký'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(answer, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }

  void _showOpeningHoursBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lịch khám chi tiết của Smile Clinic',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            _buildTimeRow('Thứ 2 - Thứ 6', '08:00 - 18:00'),
            const Divider(),
            _buildTimeRow('Thứ 7', '08:00 - 17:00'),
            const Divider(),
            _buildTimeRow('Chủ nhật & Ngày Lễ', 'Nghỉ'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đã hiểu', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin liên hệ Smile Clinic',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
            ),
            const SizedBox(height: 16),
            _buildContactRow(Icons.location_on, 'Địa chỉ', '123 Đường ABC, Quận 1, TP.HCM'),
            const Divider(),
            _buildContactRow(Icons.phone, 'Điện thoại', '0901234567'),
            const Divider(),
            _buildContactRow(Icons.email, 'Email', 'info@dakhoasmile.com'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
