import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/appointment.dart';
import '../theme/app_theme.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Appointment appointment;
  const AppointmentDetailScreen({Key? key, required this.appointment}) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  late String _currentStatus;
  late TextEditingController _notesController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.appointment.status;
    _notesController = TextEditingController(text: widget.appointment.notes ?? '');
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Chi tiết lịch khám'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thông tin lịch khám', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildInfoRow('Mã lịch khám', widget.appointment.appointmentCode),
                        const Divider(height: 24),
                        _buildInfoRow('Bệnh nhân', '${widget.appointment.patientName} (${widget.appointment.phone ?? ''})'),
                        const Divider(height: 24),
                        _buildInfoRow('Bác sĩ', widget.appointment.doctorName ?? 'Chưa phân công'),
                        const Divider(height: 24),
                        _buildInfoRow('Dịch vụ', widget.appointment.serviceName ?? 'Không xác định'),
                        const Divider(height: 24),
                        _buildInfoRow('Ngày khám', DateFormat('dd/MM/yyyy').format(widget.appointment.appointmentDate)),
                        const Divider(height: 24),
                        _buildInfoRow('Giờ khám', widget.appointment.appointmentTime),
                        const Divider(height: 24),
                        _buildInfoRow('Nguồn đăng ký', widget.appointment.sourceDisplayName),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Cập nhật trạng thái', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'Trạng thái hiện tại ',
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 14),
                              children: [
                                TextSpan(text: '*', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _currentStatus,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.access_time, color: Colors.orange, size: 20),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'pending', child: Text('Chờ khám')),
                              DropdownMenuItem(value: 'confirmed', child: Text('Đã xác nhận')),
                              DropdownMenuItem(value: 'in_progress', child: Text('Đang khám')),
                              DropdownMenuItem(value: 'completed', child: Text('Đã khám')),
                              DropdownMenuItem(value: 'cancelled', child: Text('Hủy')),
                            ],
                            onChanged: (v) => setState(() => _currentStatus = v!),
                          ),
                          const SizedBox(height: 16),
                          const Text('Ghi chú', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _notesController,
                            maxLines: 4,
                            maxLength: 200,
                            decoration: InputDecoration(
                              hintText: 'Nhập ghi chú...',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _saveChanges,
                    child: const Text('Lưu thay đổi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        ),
        Expanded(
          flex: 3,
          child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        ),
      ],
    );
  }

  void _saveChanges() async {
    // Demo error validation
    if (widget.appointment.status == 'completed' && _currentStatus != 'completed') {
      _showErrorDialog();
      return;
    }
    
    // Check if the user changes an old date to "Chờ khám"
    if (widget.appointment.appointmentDate.isBefore(DateTime.now().subtract(const Duration(days: 1))) && 
        _currentStatus == 'pending') {
      _showErrorSnackbar();
      return;
    }

    final provider = context.read<AppProvider>();
    final updated = widget.appointment.copyWith(
      status: _currentStatus,
      notes: _notesController.text.trim(),
      updatedAt: DateTime.now(),
    );
    try {
      await provider.updateAppointment(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã cập nhật trạng thái lịch khám')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text('Thông báo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text(
                'Khoảng thời gian không hợp lệ hoặc bạn không có quyền thay đổi trạng thái.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Đóng', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red[100],
        content: Row(
          children: [
            const Icon(Icons.cancel, color: Colors.red),
            const SizedBox(width: 8),
            const Text(
              'Bạn không có quyền thực hiện chức năng này.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            InkWell(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: const Icon(Icons.close, color: Colors.red, size: 16),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
