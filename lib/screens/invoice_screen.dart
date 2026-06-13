import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/invoice.dart';
import '../theme/app_theme.dart';
import 'invoice_form_screen.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  String _filterStatus = 'all';
  String _searchQuery = '';
  
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  final currencyFmt = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hóa đơn thanh toán'),
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
          _buildSummary(),
          _buildFilter(),
          Expanded(child: _buildList()),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final total = provider.totalRevenue;
        final unpaid = provider.unpaidAmount;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, AppTheme.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildStat('Đã thanh toán', currencyFmt.format(total), Icons.check_circle, Colors.white),
              ),
              Container(width: 1, height: 50, color: Colors.white24),
              Expanded(
                child: _buildStat('Chưa thanh toán', currencyFmt.format(unpaid), Icons.pending, Colors.yellow[100]!),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Tìm tên bệnh nhân, mã hóa đơn...',
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
          Row(
            children: [
              ('all', 'Tất cả'),
              ('unpaid', 'Chưa TT'),
              ('paid', 'Đã TT'),
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildList() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        var invoices = provider.invoices;

        if (_filterStatus != 'all') {
          invoices = invoices.where((i) => i.status == _filterStatus).toList();
        }

        if (_searchQuery.isNotEmpty) {
          final q = _searchQuery.toLowerCase();
          invoices = invoices
              .where((i) =>
                  i.patientName.toLowerCase().contains(q) ||
                  i.invoiceCode.toLowerCase().contains(q))
              .toList();
        }

        if (invoices.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Chưa có hóa đơn nào',
                    style: TextStyle(color: Colors.grey[600], fontSize: 15)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo hóa đơn'),
                  onPressed: () => _navigateToForm(),
                ),
              ],
            ),
          );
        }

        // Pagination
        final int totalPages = (invoices.length / _itemsPerPage).ceil();
        final int startIndex = (_currentPage - 1) * _itemsPerPage;
        final int endIndex = (startIndex + _itemsPerPage < invoices.length) 
            ? startIndex + _itemsPerPage 
            : invoices.length;
        
        final pagedInvoices = invoices.sublist(startIndex, endIndex);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pagedInvoices.length,
                itemBuilder: (ctx, i) => _buildCard(ctx, pagedInvoices[i], provider),
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

  Widget _buildCard(BuildContext context, Invoice invoice, AppProvider provider) {
    final isPaid = invoice.isPaid;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToForm(invoice: invoice),
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
                    child: Text(invoice.invoiceCode,
                        style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(invoice.patientName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isPaid ? Colors.green : Colors.orange).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(invoice.statusDisplayName,
                        style: TextStyle(
                            color: isPaid ? Colors.green : Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (action) {
                      if (action == 'edit') _navigateToForm(invoice: invoice);
                      if (action == 'delete') _confirmDelete(context, invoice, provider);
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Cập nhật')),
                      const PopupMenuItem(value: 'delete', child: Text('Xóa', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Items summary
              ...invoice.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.fiber_manual_record,
                            size: 8, color: AppTheme.textSecondary),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text(
                                '${item.name} x${item.quantity}',
                                style: const TextStyle(fontSize: 13))),
                        Text(currencyFmt.format(item.total),
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )),
              const Divider(height: 16),
              Row(
                children: [
                  const Icon(Icons.payment, size: 15, color: AppTheme.textSecondary),
                  const SizedBox(width: 6),
                  Text(invoice.paymentMethodDisplayName,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                  const Spacer(),
                  Text('Tổng: ',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(currencyFmt.format(invoice.totalAmount),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isPaid ? Colors.green : AppTheme.primaryColor)),
                ],
              ),
              if (!isPaid) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text('Xác nhận thanh toán'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => _confirmPayment(context, invoice, provider),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Invoice invoice, AppProvider provider) {
    if (invoice.isPaid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể xóa hóa đơn đã chốt (đã thanh toán)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa hóa đơn "${invoice.invoiceCode}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteInvoice(invoice.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Đã xóa hóa đơn')));
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmPayment(BuildContext context, Invoice invoice, AppProvider provider) {
    String selectedMethod = invoice.paymentMethod;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận thanh toán'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hóa đơn: ${invoice.invoiceCode}'),
            Text('Bệnh nhân: ${invoice.patientName}'),
            Text('Số tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(invoice.totalAmount)}'),
            const SizedBox(height: 12),
            StatefulBuilder(
              builder: (ctx, setS) => DropdownButtonFormField<String>(
                value: selectedMethod,
                decoration: const InputDecoration(labelText: 'Phương thức'),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('Tiền mặt')),
                  DropdownMenuItem(value: 'transfer', child: Text('Chuyển khoản')),
                  DropdownMenuItem(value: 'card', child: Text('Thẻ')),
                ],
                onChanged: (v) => setS(() => selectedMethod = v!),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              provider.markInvoicePaid(invoice.id, selectedMethod);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xác nhận thanh toán')));
            },
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToForm({Invoice? invoice}) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => InvoiceFormScreen(invoice: invoice))).then((_) => setState(() {}));
  }
}
