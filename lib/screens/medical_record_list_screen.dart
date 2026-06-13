import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../providers/auth_provider.dart';
import '../models/medical_record.dart';
import '../theme/app_theme.dart';
import 'medical_record_form_screen.dart';

class MedicalRecordListScreen extends StatefulWidget {
  final String? filterDoctorId; // For doctor view: only show their records
  const MedicalRecordListScreen({Key? key, this.filterDoctorId}) : super(key: key);

  @override
  State<MedicalRecordListScreen> createState() => _MedicalRecordListScreenState();
}

class _MedicalRecordListScreenState extends State<MedicalRecordListScreen> {
  String _filterStatus = 'all';
  String _searchQuery = '';
  
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ khám bệnh'),
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
          _buildSearchAndFilter(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm tên bệnh nhân, mã hồ sơ...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (v) => setState(() {
              _searchQuery = v;
              _currentPage = 1;
            }),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ('all', 'Tất cả'),
                ('examining', 'Đang khám'),
                ('completed', 'Hoàn tất'),
                ('cancelled', 'Đã hủy'),
              ].map((item) {
                final selected = _filterStatus == item.$1;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item.$2),
                    selected: selected,
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                        color: selected ? Colors.white : null,
                        fontSize: 12),
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

  Widget _buildList() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        var records = widget.filterDoctorId != null
            ? provider.getMedicalRecordsByDoctor(widget.filterDoctorId!)
            : provider.medicalRecords;

        if (_filterStatus != 'all') {
          records = records.where((r) => r.status == _filterStatus).toList();
        }

        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          records = records
              .where((r) =>
                  r.patientName.toLowerCase().contains(q) ||
                  r.recordCode.toLowerCase().contains(q) ||
                  r.diagnosis.toLowerCase().contains(q))
              .toList();
        }

        if (records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Chưa có hồ sơ khám nào',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                const SizedBox(height: 12),
                if (_searchQuery.isEmpty && _filterStatus == 'all')
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm hồ sơ khám'),
                    onPressed: () => _navigateToForm(),
                  ),
              ],
            ),
          );
        }

        // Pagination
        final int totalPages = (records.length / _itemsPerPage).ceil();
        final int startIndex = (_currentPage - 1) * _itemsPerPage;
        final int endIndex = (startIndex + _itemsPerPage < records.length) 
            ? startIndex + _itemsPerPage 
            : records.length;
        
        final pagedRecords = records.sublist(startIndex, endIndex);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: pagedRecords.length,
                itemBuilder: (ctx, i) => _buildCard(ctx, pagedRecords[i], provider),
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

  Widget _buildCard(BuildContext context, MedicalRecord record, AppProvider provider) {
    final statusColor = _getStatusColor(record.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToForm(record: record),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(record.recordCode,
                        style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(record.patientName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(record.statusDisplayName,
                        style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.medical_information, size: 14, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(record.doctorName,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(width: 16),
                  const Icon(Icons.calendar_today, size: 13, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(DateFormat('dd/MM/yyyy').format(record.createdAt),
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Text('Triệu chứng: ${record.symptoms ?? "Không có"}',
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('Chẩn đoán: ${record.diagnosis.isEmpty ? "Chưa có" : record.diagnosis}',
                  style: const TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              if (record.treatment.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text('Điều trị: ${record.treatment}',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Sửa'),
                    onPressed: () => _navigateToForm(record: record),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                    label: const Text('Xóa', style: TextStyle(color: Colors.red)),
                    onPressed: () => _confirmDelete(context, record, provider),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'examining':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _confirmDelete(BuildContext context, MedicalRecord r, AppProvider provider) {
    // Check if the medical record is linked to any invoice
    final hasInvoice = provider.invoices.any((i) => i.medicalRecordId == r.id);
    if (hasInvoice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể xóa hồ sơ đã phát sinh thanh toán'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa hồ sơ "${r.recordCode}" của ${r.patientName}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteMedicalRecord(r.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Đã xóa hồ sơ khám')));
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToForm({MedicalRecord? record}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => MedicalRecordFormScreen(record: record))).then((_) => setState(() {}));
  }
}
