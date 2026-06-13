import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../models/medication.dart';
import '../theme/app_theme.dart';
import 'medication_form_screen.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({Key? key}) : super(key: key);

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thuốc'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _navigateToMedicationForm(),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          if (provider.medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Không có thuốc nào',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.medications.length,
            itemBuilder: (context, index) {
              final medication = provider.medications[index];
              return _buildMedicationCard(context, medication);
            },
          );
        },
      ),
    );
  }

  Widget _buildMedicationCard(BuildContext context, Medication medication) {
    final isLowStock = medication.quantity < 10;
    final isExpired = medication.expirationDate != null && 
                       medication.expirationDate!.isBefore(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToMedicationForm(medication: medication),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.medication,
                    color: isLowStock || isExpired ? AppTheme.warningColor : AppTheme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medication.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isLowStock 
                                    ? AppTheme.warningColor.withOpacity(0.1)
                                    : AppTheme.successColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${medication.quantity} ${medication.unit}',
                                style: TextStyle(
                                  color: isLowStock ? AppTheme.warningColor : AppTheme.successColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            if (isExpired) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.errorColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Hết hạn',
                                  style: TextStyle(
                                    color: AppTheme.errorColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _updateQuantity(medication, 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: medication.quantity > 0 
                        ? () => _updateQuantity(medication, -1)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildPriceInfo('Giá nhập', medication.importPrice),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPriceInfo('Giá bán', medication.sellingPrice),
                  ),
                ],
              ),
              if (medication.expirationDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 16, color: AppTheme.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      'Hạn sử dụng: ${DateFormat('dd/MM/yyyy').format(medication.expirationDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExpired ? AppTheme.errorColor : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String label, double price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
        Text(
          NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _updateQuantity(Medication medication, int change) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final newQuantity = medication.quantity + change;
    if (newQuantity >= 0) {
      provider.updateMedicationQuantity(medication.id, newQuantity);
    }
  }

  void _navigateToMedicationForm({Medication? medication}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicationFormScreen(medication: medication),
      ),
    );
    setState(() {});
  }
}
