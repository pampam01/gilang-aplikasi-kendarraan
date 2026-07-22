import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../models/vehicle_model.dart';
import '../../../core/utils/formatters.dart';

class ReportPreviewPage extends StatefulWidget {
  final Map<String, dynamic> filters;

  const ReportPreviewPage({Key? key, required this.filters}) : super(key: key);

  @override
  State<ReportPreviewPage> createState() => _ReportPreviewPageState();
}

class _ReportPreviewPageState extends State<ReportPreviewPage> {
  bool _isLoading = true;
  List<VehicleModel> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final allVehicles = await MockRepository().getVehicles();
    
    // Simulate filtering based on parameters
    _data = allVehicles.where((v) {
      if (widget.filters['opd'] != 'Semua' && v.namaOpd != widget.filters['opd']) return false;
      if (widget.filters['kondisi'] != 'Semua' && v.kondisi != widget.filters['kondisi']) return false;
      if (widget.filters['jenisKendaraan'] != 'Semua' && v.jenisKendaraan != widget.filters['jenisKendaraan']) return false;
      return true;
    }).toList();

    setState(() {
      _isLoading = false;
    });
  }

  void _cetakPdf() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur ekspor PDF akan tersedia setelah integrasi backend.'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final String tanggalCetak = DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Laporan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _cetakPdf,
            tooltip: 'Cetak PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(AppSizes.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Laporan
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: AppSizes.p16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'PEMERINTAH KABUPATEN MUARO JAMBI',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Text(
                          'BADAN PENGELOLAAN KEUANGAN DAN ASET DAERAH',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Text(
                          'Komp. Perkantoran Bukit Cinto Kenang',
                          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(thickness: 2, height: 32, color: Colors.black),
              
              // Judul
              Text(
                widget.filters['jenis'].toString().toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: AppSizes.p16),
              
              // Info Laporan
              Text('Tanggal Cetak: $tanggalCetak'),
              if (widget.filters['opd'] != 'Semua') Text('OPD: ${widget.filters['opd']}'),
              const SizedBox(height: AppSizes.p16),
              
              // Tabel Data
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(AppColors.primary.withOpacity(0.1)),
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columns: const [
                    DataColumn(label: Text('No')),
                    DataColumn(label: Text('Nomor Polisi')),
                    DataColumn(label: Text('Merek/Tipe')),
                    DataColumn(label: Text('Tahun')),
                    DataColumn(label: Text('Kondisi')),
                    DataColumn(label: Text('OPD')),
                    DataColumn(label: Text('Nilai Aset')),
                  ],
                  rows: List.generate(_data.length, (index) {
                    final v = _data[index];
                    return DataRow(cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(v.nomorPolisi)),
                      DataCell(Text('${v.merek} ${v.tipe}')),
                      DataCell(Text('${v.tahunPerolehan}')),
                      DataCell(Text(v.kondisi)),
                      DataCell(Text(v.namaOpd)),
                      DataCell(Text(Formatters.formatRupiah(v.nilaiAset))),
                    ]);
                  }),
                ),
              ),
              
              const SizedBox(height: AppSizes.p32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      const Text('Mengetahui,'),
                      const SizedBox(height: 60),
                      const Text('( ........................................ )', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('NIP. ..............................'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cetakPdf,
        icon: const Icon(Icons.print),
        label: const Text('Cetak PDF'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
