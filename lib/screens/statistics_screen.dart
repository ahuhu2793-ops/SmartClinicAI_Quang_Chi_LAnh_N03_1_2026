import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê'),
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionTitle('Tổng quan'),
              const SizedBox(height: 16),
              _buildOverviewStats(provider),
              const SizedBox(height: 24),
              _buildSectionTitle('Lịch hẹn'),
              const SizedBox(height: 16),
              _buildAppointmentStats(provider),
              const SizedBox(height: 24),
              _buildSectionTitle('Bệnh nhân'),
              const SizedBox(height: 16),
              _buildPatientStats(provider),
              const SizedBox(height: 24),
              _buildSectionTitle('Dịch vụ'),
              const SizedBox(height: 16),
              _buildServiceStats(provider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildOverviewStats(AppProvider provider) {
    final totalRevenue = provider.completedAppointments.fold<double>(
      0,
      (sum, appointment) {
        final service = provider.services.firstWhere(
          (s) => s.id == appointment.serviceId,
          orElse: () => provider.services.first,
        );
        return sum + service.price;
      },
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Tổng doanh thu', NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalRevenue), Icons.attach_money, Colors.green),
            const Divider(),
            _buildStatRow('Tổng bệnh nhân', provider.patients.length.toString(), Icons.people, AppTheme.primaryColor),
            const Divider(),
            _buildStatRow('Tổng lịch hẹn', provider.appointments.length.toString(), Icons.calendar_month, AppTheme.secondaryColor),
            const Divider(),
            _buildStatRow('Tổng dịch vụ', provider.services.length.toString(), Icons.medical_services, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentStats(AppProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Lịch hẹn hôm nay', provider.todayAppointments.length.toString(), Icons.today, AppTheme.primaryColor),
            const Divider(),
            _buildStatRow('Đã đặt', provider.scheduledAppointments.length.toString(), Icons.schedule, Colors.blue),
            const Divider(),
            _buildStatRow('Hoàn thành', provider.completedAppointments.length.toString(), Icons.check_circle, Colors.green),
            const Divider(),
            _buildStatRow('Đang khám', provider.appointments.where((a) => a.status == 'in_progress').length.toString(), Icons.access_time, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientStats(AppProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Đang điều trị', provider.activePatients.length.toString(), Icons.healing, Colors.blue),
            const Divider(),
            _buildStatRow('Đã điều trị', provider.completedPatients.length.toString(), Icons.done_all, Colors.green),
            const Divider(),
            _buildStatRow('Tỷ lệ hoàn thành', '${provider.patients.isEmpty ? 0 : ((provider.completedPatients.length / provider.patients.length) * 100).toStringAsFixed(1)}%', Icons.percent, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStats(AppProvider provider) {
    final mostPopularService = provider.services.isNotEmpty
        ? provider.services.reduce((a, b) => a.price > b.price ? a : b)
        : null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatRow('Tổng dịch vụ', provider.services.length.toString(), Icons.medical_services, AppTheme.primaryColor),
            const Divider(),
            _buildStatRow('Dịch vụ đang kích hoạt', provider.activeServices.length.toString(), Icons.check_circle, Colors.green),
            const Divider(),
            if (mostPopularService != null)
              _buildStatRow('Dịch vụ giá cao nhất', mostPopularService.name, Icons.star, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
