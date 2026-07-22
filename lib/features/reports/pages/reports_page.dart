import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../data/repositories/mock_repository.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _jenisLaporan = 'Laporan Seluruh Kendaraan';
  String _opd = 'Semua';
  String _kondisi = 'Semua';
  String _jenisKendaraan = 'Semua';
  String _tahun = 'Semua';
  
  List<String> _opdList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOpds();
  }

  Future<void> _loadOpds() async {
    final opds = await MockRepository().getOpds();
    setState(() {
      _opdList = opds.map((e) => e.namaOpd).toList();
      _isLoading = false;
    });
  }

  void _resetFilters() {
    setState(() {
      _jenisLaporan = 'Laporan Seluruh Kendaraan';
      _opd = 'Semua';
      _kondisi = 'Semua';
      _jenisKendaraan = 'Semua';
      _tahun = 'Semua';
    });
  }

  void _tampilkanLaporan() {
    context.push('/reports/preview', extra: {
      'jenis': _jenisLaporan,
      'opd': _opd,
      'kondisi': _kondisi,
      'jenisKendaraan': _jenisKendaraan,
      'tahun': _tahun,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Aset'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filter Laporan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSizes.p16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _jenisLaporan,
                      decoration: const InputDecoration(labelText: 'Jenis Laporan'),
                      items: [
                        'Laporan Seluruh Kendaraan',
                        'Laporan Berdasarkan OPD',
                        'Laporan Berdasarkan Kondisi',
                        'Laporan Berdasarkan Jenis Kendaraan',
                        'Laporan Hasil Klasifikasi',
                      ].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) => setState(() => _jenisLaporan = val!),
                    ),
                    const SizedBox(height: AppSizes.p16),
                    DropdownButtonFormField<String>(
                      value: _opd,
                      decoration: const InputDecoration(labelText: 'OPD'),
                      items: ['Semua', ..._opdList].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: _jenisLaporan == 'Laporan Berdasarkan OPD' || _jenisLaporan == 'Laporan Seluruh Kendaraan'
                          ? (val) => setState(() => _opd = val!)
                          : null,
                    ),
                    const SizedBox(height: AppSizes.p16),
                    DropdownButtonFormField<String>(
                      value: _kondisi,
                      decoration: const InputDecoration(labelText: 'Kondisi'),
                      items: ['Semua', 'Baik', 'Rusak Ringan', 'Rusak Berat'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: _jenisLaporan == 'Laporan Berdasarkan Kondisi' || _jenisLaporan == 'Laporan Seluruh Kendaraan'
                          ? (val) => setState(() => _kondisi = val!)
                          : null,
                    ),
                    const SizedBox(height: AppSizes.p16),
                    DropdownButtonFormField<String>(
                      value: _jenisKendaraan,
                      decoration: const InputDecoration(labelText: 'Jenis Kendaraan'),
                      items: ['Semua', 'Mobil Penumpang', 'Mobil Barang', 'Sepeda Motor', 'Kendaraan Khusus'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: _jenisLaporan == 'Laporan Berdasarkan Jenis Kendaraan' || _jenisLaporan == 'Laporan Seluruh Kendaraan'
                          ? (val) => setState(() => _jenisKendaraan = val!)
                          : null,
                    ),
                    const SizedBox(height: AppSizes.p16),
                    DropdownButtonFormField<String>(
                      value: _tahun,
                      decoration: const InputDecoration(labelText: 'Tahun Perolehan'),
                      items: ['Semua', '2024', '2023', '2022', '2021', '2020', '< 2020'].map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (val) => setState(() => _tahun = val!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.p32),
            PrimaryButton(
              text: 'Tampilkan Laporan',
              onPressed: _tampilkanLaporan,
            ),
            const SizedBox(height: AppSizes.p12),
            OutlinedButton(
              onPressed: _resetFilters,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.p16),
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                ),
              ),
              child: const Text('Reset Filter'),
            ),
          ],
        ),
      ),
    );
  }
}
