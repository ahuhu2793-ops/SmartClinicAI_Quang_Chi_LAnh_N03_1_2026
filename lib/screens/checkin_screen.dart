import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../models/checkin.dart';
import '../theme/app_theme.dart';
import 'checkin_form_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  DateTime _selectedDate = DateTime.now();
  String _filterStatus = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiếp đón bệnh nhân'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToForm(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      child: Column(
        children: [
          // Date row
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => setState(() {
                  _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                  _currentPage = 1;
                }),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (d != null) {
                      setState(() {
                        _selectedDate = d;
                        _currentPage = 1;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('EEEE, dd/MM/yyyy', 'vi').format(_selectedDate),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => setState(() {
                  _selectedDate = _selectedDate.add(const Duration(days: 1));
                  _currentPage = 1;
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ('all', 'Tất cả'),
                ('waiting', 'Chờ khám'),
                ('in_progress', 'Đang khám'),
                ('done', 'Đã xong'),
                ('cancelled', 'Đã hủy'),
              ].map((item) {
                final selected = _filterStatus == item.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item.$2),
                    selected: selected,
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(color: selected ? Colors.white : null, fontSize: 12),
                    onSelected: (_) => setState(() {
                      _filterStatus = item.$1;
                      _currentPage = 1;
                    }),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm theo tên hoặc mã phiếu...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _currentPage = 1;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
            _currentPage = 1;
          });
        },
      ),
    );
  }

  Widget _buildList() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        var checkins = provider.getCheckinsByDate(_selectedDate);
        
        // Filter by status
        if (_filterStatus != 'all') {
          checkins = checkins.where((c) => c.status == _filterStatus).toList();
        }
        
        // Filter by search query
        if (_searchQuery.isNotEmpty) {
          checkins = checkins.where((c) => 
            c.patientName.toLowerCase().contains(_searchQuery) ||
            c.checkinCode.toLowerCase().contains(_searchQuery)
          ).toList();
        }

        if (checkins.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.how_to_reg, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Không có dữ liệu', style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                const SizedBox(height: 12),
                if (_searchQuery.isEmpty && _filterStatus == 'all')
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm phiếu tiếp đón'),
                    onPressed: () => _navigateToForm(),
                  ),
              ],
            ),
          );
        }

        // Pagination
        final int totalPages = (checkins.length / _itemsPerPage).ceil();
        final int startIndex = (_currentPage - 1) * _itemsPerPage;
        final int endIndex = (startIndex + _itemsPerPage < checkins.length) 
            ? startIndex + _itemsPerPage 
            : checkins.length;
        
        final pagedCheckins = checkins.sublist(startIndex, endIndex);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pagedCheckins.length,
                itemBuilder: (ctx, i) => _buildCard(ctx, pagedCheckins[i], provider),
              ),
            ),
            _buildPagination(totalPages),
          ],
        );
      },
    );
  }

  Widget _buildPagination(int totalPages) {
    if (totalPages <= 1) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 1 
                ? () => setState(() => _currentPage--) 
                : null,
          ),
          Text('Trang $_currentPage / $totalPages'),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages 
                ? () => setState(() => _currentPage++) 
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, CheckIn checkIn, AppProvider provider) {
    final statusColor = _getStatusColor(checkIn.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToForm(checkIn: checkIn),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(checkIn.checkinTime,
                        style: const TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(checkIn.patientName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(checkIn.checkinCode, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Bác sĩ: ${checkIn.doctorName}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                        if (checkIn.appointmentId != null)
                          const Text('Có lịch hẹn', style: TextStyle(color: Colors.blue, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(checkIn.statusDisplayName,
                        style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (action) {
                      if (action == 'edit') _navigateToForm(checkIn: checkIn);
                      if (action == 'delete') _confirmDelete(context, checkIn, provider);
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Cập nhật')),
                      const PopupMenuItem(value: 'delete', child: Text('Hủy/Xóa', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
              if (checkIn.notes != null && checkIn.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.note, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(checkIn.notes!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting': return Colors.orange;
      case 'in_progress': return Colors.blue;
      case 'done': return Colors.green;
      case 'cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  void _confirmDelete(BuildContext context, CheckIn c, AppProvider provider) {
    if (c.status == 'in_progress' || c.status == 'done') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể xóa phiếu đã được sử dụng'),
          backgroundColor: Colors.red,
        )
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa phiếu tiếp đón "${c.checkinCode}" của "${c.patientName}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteCheckIn(c.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa phiếu tiếp đón')));
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToForm({CheckIn? checkIn}) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CheckInFormScreen(checkIn: checkIn))).then((_) => setState(() {}));
  }
}
