import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';
import 'appointment_form_screen.dart';
import 'appointment_detail_screen.dart';

class AppointmentScreen extends StatefulWidget {
  final String? filterDoctorId;
  const AppointmentScreen({Key? key, this.filterDoctorId}) : super(key: key);

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  String _filterDoctorId = 'all';
  String _filterStatus = 'all';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.filterDoctorId != null) {
      _filterDoctorId = widget.filterDoctorId!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.filterDoctorId != null ? 'Lịch hẹn của tôi' : 'Theo dõi lịch khám'),
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () => _navigateToAppointmentForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              tabs: const [
                Tab(text: 'Danh sách'),
                Tab(text: 'Lịch theo ngày'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListView(),
                _buildTimelineView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) setState(() => _selectedDate = date);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 13)),
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Consumer<AppProvider>(
              builder: (context, provider, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _filterDoctorId,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      items: [
                        const DropdownMenuItem(value: 'all', child: Text('Tất cả bác sĩ', overflow: TextOverflow.ellipsis)),
                        ...provider.doctors.map((d) => DropdownMenuItem(value: d.id, child: Text(d.name, overflow: TextOverflow.ellipsis))),
                      ],
                      onChanged: widget.filterDoctorId != null 
                        ? null 
                        : (v) => setState(() => _filterDoctorId = v!),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _filterStatus,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Tất cả trạng thái', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'pending', child: Text('Chờ xác nhận', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'confirmed', child: Text('Đã xác nhận', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'in_progress', child: Text('Đang khám', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'completed', child: Text('Đã khám', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'cancelled', child: Text('Đã hủy', overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (v) => setState(() => _filterStatus = v!),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Appointment> _getFilteredAppointments(AppProvider provider) {
    return provider.appointments.where((a) {
      final dateMatch = a.appointmentDate.year == _selectedDate.year &&
          a.appointmentDate.month == _selectedDate.month &&
          a.appointmentDate.day == _selectedDate.day;
      final docMatch = _filterDoctorId == 'all' || a.doctorId == _filterDoctorId;
      final statusMatch = _filterStatus == 'all' || 
          (_filterStatus == 'completed' && a.status == 'completed') ||
          (_filterStatus == 'pending' && a.status == 'pending') ||
          (_filterStatus == 'confirmed' && a.status == 'confirmed') ||
          (_filterStatus == 'in_progress' && a.status == 'in_progress') ||
          (_filterStatus == 'cancelled' && a.status == 'cancelled');
      return dateMatch && docMatch && statusMatch;
    }).toList()
    ..sort((a, b) => a.appointmentTime.compareTo(b.appointmentTime));
  }

  Widget _buildListView() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final appointments = _getFilteredAppointments(provider);
        final total = appointments.length;
        final pending = appointments.where((a) => a.status == 'pending').length;
        final inProgress = appointments.where((a) => a.status == 'in_progress').length;
        final completed = appointments.where((a) => a.status == 'completed').length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary cards
              Row(
                children: [
                  Expanded(child: _buildSummaryCard('Tổng lịch', total.toString(), Icons.calendar_month, Colors.blue[50]!, Colors.blue)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSummaryCard('Chờ khám', pending.toString(), Icons.access_time, Colors.orange[50]!, Colors.orange)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSummaryCard('Đang khám', inProgress.toString(), Icons.person, Colors.green[50]!, Colors.green)),
                  const SizedBox(width: 8),
                  Expanded(child: _buildSummaryCard('Đã khám', completed.toString(), Icons.check_circle_outline, Colors.blue[100]!, Colors.blue[800]!)),
                ],
              ),
              const SizedBox(height: 24),
              // List header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Danh sách lịch khám', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Tổng: $total lịch', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 12),
              // Table header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: const Row(
                  children: [
                    Expanded(flex: 1, child: Text('Giờ khám', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('Bệnh nhân', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('Bác sĩ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('Dịch vụ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                    Expanded(flex: 2, child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  ],
                ),
              ),
              // Table rows
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey[200]!),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
                ),
                child: appointments.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: Text('Không có dữ liệu')),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appointments.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey[200]),
                        itemBuilder: (context, index) {
                          final a = appointments[index];
                          return InkWell(
                            onTap: () => _navigateToDetail(a),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: Row(
                                children: [
                                  Expanded(flex: 1, child: Text(a.appointmentTime, style: const TextStyle(fontSize: 13))),
                                  Expanded(flex: 2, child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundColor: Colors.blue[100],
                                        child: Text(a.patientName.substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.blue)),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(a.patientName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                                            Text(a.phone ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                  Expanded(flex: 2, child: Text(a.doctorName ?? '', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 2, child: Text(a.serviceName ?? '', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                                  Expanded(flex: 2, child: Align(alignment: Alignment.centerLeft, child: _buildStatusLabel(a.status))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String count, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgColor.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[700]), overflow: TextOverflow.ellipsis),
            ],
          ),
          const SizedBox(height: 8),
          Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTimelineView() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final appointments = _getFilteredAppointments(provider);
        final total = appointments.length;
        final pending = appointments.where((a) => a.status == 'pending').length;
        final inProgress = appointments.where((a) => a.status == 'in_progress').length;
        final completed = appointments.where((a) => a.status == 'completed').length;
        final cancelled = appointments.where((a) => a.status == 'cancelled').length;

        return Column(
          children: [
            // Status chips
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tổng: $total lịch khám', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatusCountChip('Chờ khám', pending, Colors.orange),
                        const SizedBox(width: 8),
                        _buildStatusCountChip('Đang khám', inProgress, Colors.green),
                        const SizedBox(width: 8),
                        _buildStatusCountChip('Đã khám', completed, Colors.blue),
                        const SizedBox(width: 8),
                        _buildStatusCountChip('Hủy', cancelled, Colors.red),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Timeline list
            Expanded(
              child: appointments.isEmpty
                  ? const Center(child: Text('Không có dữ liệu'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final a = appointments[index];
                        final color = _getStatusColor(a.status);
                        return InkWell(
                          onTap: () => _navigateToDetail(a),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(a.appointmentTime, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: index == appointments.length - 1 ? Colors.transparent : Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(color: Colors.grey[200]!),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${a.patientName} - ${a.doctorName ?? ''}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(a.serviceName ?? '', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                                          const SizedBox(height: 8),
                                          _buildStatusLabel(a.status),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusCountChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 4),
          Text('$label $count', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending': return Colors.orange;
      case 'confirmed': return Colors.lightGreen;
      case 'in_progress': return Colors.green;
      case 'completed': return Colors.blue;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  Widget _buildStatusLabel(String status) {
    final color = _getStatusColor(status);
    String label = '';
    switch (status) {
      case 'pending': label = 'Chờ khám'; break;
      case 'confirmed': label = 'Đã xác nhận'; break;
      case 'in_progress': label = 'Đang khám'; break;
      case 'completed': label = 'Đã khám'; break;
      case 'cancelled': label = 'Hủy'; break;
      default: label = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _navigateToAppointmentForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppointmentFormScreen()),
    );
    setState(() {});
  }

  void _navigateToDetail(Appointment appointment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentDetailScreen(appointment: appointment)),
    );
    setState(() {});
  }
}
