import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../models/classification_model.dart';
import '../../../data/mock/mock_classifications.dart';

class ClassificationsPage extends StatefulWidget {
  const ClassificationsPage({Key? key}) : super(key: key);

  @override
  State<ClassificationsPage> createState() => _ClassificationsPageState();
}

class _ClassificationsPageState extends State<ClassificationsPage> {
  String _selectedCategory = 'Berdasarkan Kondisi';
  bool _isLoading = false;
  List<ClassificationModel>? _result;

  void _processClassification() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });

    // Simulate processing time
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      if (_selectedCategory == 'Berdasarkan Kondisi') {
        _result = mockKondisiClassification;
      } else {
        _result = mockJenisClassification;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Klasifikasi Kendaraan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.p16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                border: Border.all(color: AppColors.secondary),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary),
                  SizedBox(width: AppSizes.p12),
                  Expanded(
                    child: Text(
                      'Data klasifikasi pada prototype ini menggunakan data simulasi lokal.',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Pilih Kategori Klasifikasi'),
              items: [
                'Berdasarkan Kondisi',
                'Berdasarkan Jenis Kendaraan',
                'Berdasarkan Status Penggunaan',
                'Berdasarkan OPD Pengguna'
              ].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: AppSizes.p24),
            PrimaryButton(
              text: 'Proses Klasifikasi',
              isLoading: _isLoading,
              onPressed: _processClassification,
            ),
            const SizedBox(height: AppSizes.p32),
            if (_result != null) _buildResultSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Hasil Klasifikasi',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSizes.p16),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _result!.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final colors = [
                  AppColors.primary,
                  AppColors.success,
                  AppColors.warning,
                  AppColors.error,
                  AppColors.secondary,
                ];
                final color = colors[index % colors.length];
                return PieChartSectionData(
                  color: color,
                  value: data.persentase,
                  title: '${data.persentase}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSizes.p24),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _result!.length,
          itemBuilder: (context, index) {
            final data = _result![index];
            final colors = [
              AppColors.primary,
              AppColors.success,
              AppColors.warning,
              AppColors.error,
              AppColors.secondary,
            ];
            final color = colors[index % colors.length];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(data.kategori, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text('${data.jumlah} Unit (${data.persentase}%)'),
              ),
            );
          },
        ),
      ],
    );
  }
}
