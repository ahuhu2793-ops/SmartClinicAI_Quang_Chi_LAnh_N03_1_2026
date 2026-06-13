import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Xin chào,',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Phòng Khám Đa Khoa Smile',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('EEEE, dd/MM/yyyy').format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Tổng quan'),
                      const SizedBox(height: 16),
                      _buildStatsGrid(context, provider),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Lịch hẹn hôm nay'),
                      const SizedBox(height: 16),
                      _buildTodayAppointments(context, provider),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
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

  Widget _buildStatsGrid(BuildContext context, AppProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          'Bệnh nhân',
          provider.patients.length.toString(),
          Icons.people,
          AppTheme.primaryColor,
        ),
        _buildStatCard(
          context,
          'Lịch hẹn',
          provider.appointments.length.toString(),
          Icons.calendar_month,
          AppTheme.secondaryColor,
        ),
        _buildStatCard(
          context,
          'Dịch vụ',
          provider.services.length.toString(),
          Icons.medical_services,
          Colors.orange,
        ),

      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayAppointments(BuildContext context, AppProvider provider) {
    final todayAppointments = provider.todayAppointments;
    
    if (todayAppointments.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 12),
                Text(
                  'Không có lịch hẹn hôm nay',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: todayAppointments.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final appointment = todayAppointments[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryLight,
              child: Text(
                appointment.appointmentTime.substring(0, 2),
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(appointment.patientName),
            subtitle: Text(appointment.serviceName ?? 'Chưa có dịch vụ'),
            trailing: _buildStatusChip(appointment.status),
          );
        },
      ),
    );
  }



  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'scheduled':
        color = Colors.blue;
        label = 'Đã đặt';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Hoàn thành';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Đã hủy';
        break;
      case 'in_progress':
        color = Colors.orange;
        label = 'Đang khám';
        break;
      default:
        color = Colors.grey;
        label = status;
    }
    
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontSize: 12),
    );
  }
}
