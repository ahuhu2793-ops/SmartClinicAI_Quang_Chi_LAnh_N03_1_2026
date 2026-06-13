import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';

class RevenueStatisticsScreen extends StatefulWidget {
  const RevenueStatisticsScreen({Key? key}) : super(key: key);

  @override
  State<RevenueStatisticsScreen> createState() => _RevenueStatisticsScreenState();
}

class _RevenueStatisticsScreenState extends State<RevenueStatisticsScreen> {
  // Input fields for filter form
  DateTime _startDateInput = DateTime.now().subtract(const Duration(days: 29));
  DateTime _endDateInput = DateTime.now();
  String _filterStatusInput = 'all';

  // Applied filters used for data fetching
  DateTime _appliedStartDate = DateTime.now().subtract(const Duration(days: 29));
  DateTime _appliedEndDate = DateTime.now();
  String _appliedFilterStatus = 'all';

  // Pagination
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê doanh thu'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFilters,
            tooltip: 'Đặt lại bộ lọc',
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          final stats = provider.getRevenueByDateRange(_appliedStartDate, _appliedEndDate);
          final dailyData = provider.getRevenueByDay(_appliedStartDate, _appliedEndDate);

          List<Map<String, dynamic>> filteredDaily = dailyData;
          if (_appliedFilterStatus != 'all') {
            filteredDaily = dailyData.where((d) {
              if (_appliedFilterStatus == 'paid') return (d['paid'] as double) > 0;
              if (_appliedFilterStatus == 'unpaid') return (d['total'] as double) > (d['paid'] as double);
              return true;
            }).toList();
          }

          return Column(
            children: [
              _buildFilterBar(),
              _buildSummaryCards(stats),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    Text('Chi tiết theo ngày',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
              ),
              Expanded(child: _buildDailyTable(filteredDaily)),
            ],
          );
        },
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      final now = DateTime.now();
      _startDateInput = now.subtract(const Duration(days: 29));
      _endDateInput = now;
      _filterStatusInput = 'all';

      _appliedStartDate = _startDateInput;
      _appliedEndDate = _endDateInput;
      _appliedFilterStatus = 'all';
      _currentPage = 1;
    });
  }

  void _applyFilters() {
    if (_endDateInput.isBefore(_startDateInput)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Khoảng thời gian không hợp lệ (Từ ngày lớn hơn Đến ngày)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _appliedStartDate = _startDateInput;
      _appliedEndDate = _endDateInput;
      _appliedFilterStatus = _filterStatusInput;
      _currentPage = 1;
    });
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Date range
          Row(
            children: [
              Expanded(child: _buildDatePickerTile('Từ ngày', _startDateInput, (d) {
                setState(() => _startDateInput = d);
              })),
              const SizedBox(width: 12),
              Expanded(child: _buildDatePickerTile('Đến ngày', _endDateInput, (d) {
                setState(() => _endDateInput = d);
              })),
            ],
          ),
          const SizedBox(height: 10),
          // Quick filters & Status
          Row(
            children: [
              _buildQuickFilter('7 ngày', 6),
              const SizedBox(width: 8),
              _buildQuickFilter('30 ngày', 29),
              const SizedBox(width: 8),
              _buildQuickFilter('90 ngày', 89),
              const Spacer(),
              // Status filter
              DropdownButton<String>(
                value: _filterStatusInput,
                isDense: true,
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                  DropdownMenuItem(value: 'paid', child: Text('Đã TT')),
                  DropdownMenuItem(value: 'unpaid', child: Text('Chưa TT')),
                ],
                onChanged: (v) => setState(() => _filterStatusInput = v!),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Search/Apply button
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Tìm kiếm / Áp dụng bộ lọc', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _applyFilters,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerTile(String label, DateTime date, Function(DateTime) onPick) {
    return InkWell(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (d != null) onPick(d);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          prefixIcon: const Icon(Icons.calendar_today, size: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(DateFormat('dd/MM/yyyy').format(date),
            style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  Widget _buildQuickFilter(String label, int days) {
    // Check if the input dates match the quick filter roughly
    final isActive = _startDateInput.difference(DateTime.now()).inDays.abs() == days;
    return GestureDetector(
      onTap: () => setState(() {
        _endDateInput = DateTime.now();
        _startDateInput = _endDateInput.subtract(Duration(days: days));
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                color: isActive ? Colors.white : AppTheme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStatCard('Tổng hóa đơn', '${stats['totalCount']}',
              Icons.receipt_long, Colors.blue),
          _buildStatCard('Tổng doanh thu',
              currencyFmt.format(stats['totalRevenue']),
              Icons.attach_money, AppTheme.primaryColor),
          _buildStatCard('Đã thanh toán',
              currencyFmt.format(stats['paidRevenue']),
              Icons.check_circle, Colors.green),
          _buildStatCard('Chưa thanh toán',
              currencyFmt.format(stats['unpaidRevenue']),
              Icons.pending, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 10),
                    maxLines: 1),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTable(List<Map<String, dynamic>> data) {
    // Filter out zero-activity days
    final nonEmpty = data.where((d) => (d['count'] as int) > 0).toList();

    if (nonEmpty.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Không có dữ liệu trong khoảng thời gian này',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      );
    }

    // Pagination
    final int totalPages = (nonEmpty.length / _itemsPerPage).ceil();
    final int startIndex = (_currentPage - 1) * _itemsPerPage;
    final int endIndex = (startIndex + _itemsPerPage < nonEmpty.length) 
        ? startIndex + _itemsPerPage 
        : nonEmpty.length;
    
    final pagedData = nonEmpty.sublist(startIndex, endIndex);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppTheme.primaryColor.withOpacity(0.06),
          child: const Row(
            children: [
              Expanded(flex: 2, child: Text('Ngày', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(child: Text('SL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('Tổng DT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)),
              Expanded(flex: 2, child: Text('Đã TT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.right)),
              Expanded(child: Text('TT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: pagedData.length,
            itemBuilder: (ctx, i) {
              final day = pagedData[i];
              final date = day['date'] as DateTime;
              final count = day['count'] as int;
              final total = day['total'] as double;
              final paid = day['paid'] as double;
              final status = day['status'] as String;
              final isFullyPaid = status == 'Hoàn tất';

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: i % 2 == 0 ? Colors.white : Colors.grey[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(DateFormat('dd/MM/yyyy').format(date),
                          style: const TextStyle(fontSize: 12)),
                    ),
                    Expanded(
                      child: Text('$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _shortCurrency(total),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        _shortCurrency(paid),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green[700]),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: (isFullyPaid ? Colors.green : Colors.orange).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isFullyPaid ? 'HT' : '1P',
                            style: TextStyle(
                                color: isFullyPaid ? Colors.green : Colors.orange,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildPagination(totalPages),
      ],
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

  String _shortCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
