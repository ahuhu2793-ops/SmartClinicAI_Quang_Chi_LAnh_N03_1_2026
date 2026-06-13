import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'providers/auth_provider.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/appointment_screen.dart';
import 'screens/patient_screen.dart';
import 'screens/medical_record_list_screen.dart';
import 'screens/service_screen.dart';
import 'screens/medication_screen.dart';
import 'screens/supply_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/clinic_intro_screen.dart';
import 'screens/public_services_screen.dart';
import 'screens/user_medical_records_screen.dart';
import 'screens/doctor_screen.dart';

// New Screens
import 'screens/user_management_screen.dart';
import 'screens/checkin_screen.dart';
import 'screens/invoice_screen.dart';
import 'screens/revenue_statistics_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi', null);

  // Initialize and load SQLite data
  final authProvider = AuthProvider();
  await authProvider.init();

  final appProvider = AppProvider();
  await appProvider.init();

  runApp(MyApp(
    appProvider: appProvider,
    authProvider: authProvider,
  ));
}

class MyApp extends StatelessWidget {
  final AppProvider appProvider;
  final AuthProvider authProvider;

  const MyApp({
    Key? key,
    required this.appProvider,
    required this.authProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appProvider),
        ChangeNotifierProvider.value(value: authProvider),
      ],
      child: MaterialApp(
        title: 'Quản Lý Phòng Khám',
        theme: AppTheme.lightTheme,
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isAuthenticated) {
          if (authProvider.isAdmin) {
            return const AdminNavigation();
          } else if (authProvider.isReceptionist) {
            return const ReceptionistNavigation();
          } else if (authProvider.isDoctor) {
            return const DoctorNavigation();
          } else {
            return const PatientNavigation();
          }
        } else {
          return const PublicNavigation();
        }
      },
    );
  }
}

class PublicNavigation extends StatelessWidget {
  const PublicNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ClinicIntroScreen(),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String title;
  final Widget screen;

  NavigationItem({
    required this.icon,
    required this.title,
    required this.screen,
  });
}

// ---------------------------------------------------------------------------
// ADMIN NAVIGATION
// ---------------------------------------------------------------------------
class AdminNavigation extends StatefulWidget {
  const AdminNavigation({Key? key}) : super(key: key);
  @override
  State<AdminNavigation> createState() => _AdminNavigationState();
}

class _AdminNavigationState extends State<AdminNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(icon: Icons.home, title: 'Trang chủ', screen: const HomeScreen()),
    NavigationItem(icon: Icons.people_outline, title: 'Người dùng', screen: const UserManagementScreen()),
    NavigationItem(icon: Icons.medical_information, title: 'Bác sĩ', screen: const DoctorScreen()),
    NavigationItem(icon: Icons.people, title: 'Bệnh nhân', screen: const PatientScreen()),
    NavigationItem(icon: Icons.calendar_month, title: 'Lịch hẹn', screen: const AppointmentScreen()),
    NavigationItem(icon: Icons.how_to_reg, title: 'Tiếp đón', screen: const CheckInScreen()),
    NavigationItem(icon: Icons.folder_open, title: 'Hồ sơ bệnh án', screen: const MedicalRecordListScreen()),
    NavigationItem(icon: Icons.receipt_long, title: 'Hóa đơn', screen: const InvoiceScreen()),
    NavigationItem(icon: Icons.bar_chart, title: 'Doanh thu', screen: const RevenueStatisticsScreen()),
    NavigationItem(icon: Icons.medical_services, title: 'Dịch vụ', screen: const ServiceScreen()),
    NavigationItem(icon: Icons.settings, title: 'Cài đặt', screen: const SettingsScreen()),
  ];

  @override
  Widget build(BuildContext context) => _buildScaffold(_scaffoldKey, _items, _selectedIndex, (i) => setState(() => _selectedIndex = i));
}

// ---------------------------------------------------------------------------
// RECEPTIONIST NAVIGATION
// ---------------------------------------------------------------------------
class ReceptionistNavigation extends StatefulWidget {
  const ReceptionistNavigation({Key? key}) : super(key: key);
  @override
  State<ReceptionistNavigation> createState() => _ReceptionistNavigationState();
}

class _ReceptionistNavigationState extends State<ReceptionistNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(icon: Icons.home, title: 'Trang chủ', screen: const HomeScreen()),
    NavigationItem(icon: Icons.how_to_reg, title: 'Tiếp đón', screen: const CheckInScreen()),
    NavigationItem(icon: Icons.calendar_month, title: 'Lịch hẹn', screen: const AppointmentScreen()),
    NavigationItem(icon: Icons.people, title: 'Bệnh nhân', screen: const PatientScreen()),
    NavigationItem(icon: Icons.receipt_long, title: 'Hóa đơn', screen: const InvoiceScreen()),
    NavigationItem(icon: Icons.settings, title: 'Cài đặt', screen: const SettingsScreen()),
  ];

  @override
  Widget build(BuildContext context) => _buildScaffold(_scaffoldKey, _items, _selectedIndex, (i) => setState(() => _selectedIndex = i));
}

// ---------------------------------------------------------------------------
// DOCTOR NAVIGATION
// ---------------------------------------------------------------------------
class DoctorNavigation extends StatefulWidget {
  const DoctorNavigation({Key? key}) : super(key: key);
  @override
  State<DoctorNavigation> createState() => _DoctorNavigationState();
}

class _DoctorNavigationState extends State<DoctorNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  String? _doctorId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      if (auth.currentUser != null) {
        final app = context.read<AppProvider>();
        try {
          final doc = app.doctors.firstWhere((d) => d.name.contains(auth.currentUser!.name.replaceAll('BS. ', '')));
          setState(() => _doctorId = doc.id);
        } catch (_) {}
      }
    });
  }

  List<NavigationItem> get _items => [
    NavigationItem(icon: Icons.home, title: 'Trang chủ', screen: const HomeScreen()),
    NavigationItem(icon: Icons.folder_open, title: 'Hồ sơ khám bệnh', screen: MedicalRecordListScreen(filterDoctorId: _doctorId)),
    NavigationItem(icon: Icons.calendar_month, title: 'Lịch hẹn của tôi', screen: AppointmentScreen(filterDoctorId: _doctorId)),
    NavigationItem(icon: Icons.settings, title: 'Cài đặt', screen: const SettingsScreen()),
  ];

  @override
  Widget build(BuildContext context) => _buildScaffold(_scaffoldKey, _items, _selectedIndex, (i) => setState(() => _selectedIndex = i));
}

// ---------------------------------------------------------------------------
// PATIENT NAVIGATION
// ---------------------------------------------------------------------------
class PatientNavigation extends StatefulWidget {
  const PatientNavigation({Key? key}) : super(key: key);
  @override
  State<PatientNavigation> createState() => _PatientNavigationState();
}

class _PatientNavigationState extends State<PatientNavigation> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  final List<NavigationItem> _items = [
    NavigationItem(icon: Icons.home, title: 'Trang chủ', screen: const ClinicIntroScreen()),
    NavigationItem(icon: Icons.medical_services, title: 'Dịch vụ', screen: const PublicServicesScreen()),
    NavigationItem(icon: Icons.folder_open, title: 'Hồ sơ bệnh án', screen: const UserMedicalRecordsScreen()),
    NavigationItem(icon: Icons.settings, title: 'Cài đặt', screen: const SettingsScreen()),
  ];

  @override
  Widget build(BuildContext context) => _buildScaffold(_scaffoldKey, _items, _selectedIndex, (i) => setState(() => _selectedIndex = i));
}

// ---------------------------------------------------------------------------
// SHARED SCAFFOLD BUILDER
// ---------------------------------------------------------------------------
Widget _buildScaffold(GlobalKey<ScaffoldState> key, List<NavigationItem> items, int selectedIndex, Function(int) onSelect) {
  return Builder(
    builder: (context) {
      return Scaffold(
        key: key,
        appBar: AppBar(
          title: Text(items[selectedIndex].title),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => key.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
            ),
          ],
        ),
        drawer: _buildDrawer(context, items, selectedIndex, onSelect),
        body: items[selectedIndex].screen,
      );
    }
  );
}

Widget _buildDrawer(BuildContext context, List<NavigationItem> items, int selectedIndex, Function(int) onSelect) {
  return Consumer<AuthProvider>(
    builder: (context, authProvider, child) {
      final user = authProvider.currentUser;
      final roleName = user?.roleDisplayName ?? 'Khách';
      
      Color roleColor = Colors.grey;
      if (authProvider.isAdmin) roleColor = Colors.orange;
      else if (authProvider.isReceptionist) roleColor = Colors.blue;
      else if (authProvider.isDoctor) roleColor = AppTheme.primaryColor;
      else if (authProvider.isPatient) roleColor = Colors.purple;

      return Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Text(
                        user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user?.name ?? 'Người dùng',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: roleColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            roleName,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user?.email ?? '',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  final isSelected = selectedIndex == i;
                  return ListTile(
                    leading: Icon(item.icon, color: isSelected ? AppTheme.primaryColor : Colors.grey[700]),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedTileColor: AppTheme.primaryColor.withOpacity(0.08),
                    onTap: () {
                      onSelect(i);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorColor),
              title: const Text('Đăng xuất', style: TextStyle(color: AppTheme.errorColor)),
              onTap: () {
                authProvider.logout();
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
