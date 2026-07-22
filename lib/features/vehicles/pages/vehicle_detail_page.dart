import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/vehicle_model.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vehicles_provider.dart';

class VehicleDetailPage extends ConsumerWidget {
  final VehicleModel vehicle;

  const VehicleDetailPage({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kendaraan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/vehicles/edit', extra: vehicle),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.directions_car,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            Text(
              vehicle.nomorPolisi,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '${vehicle.merek} ${vehicle.tipe}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildConditionBadge(vehicle.kondisi),
                const SizedBox(width: AppSizes.p16),
                _buildStatusBadge(vehicle.statusPenggunaan),
              ],
            ),
            const SizedBox(height: AppSizes.p32),
            _buildSection(
              context,
              'Identitas Kendaraan',
              [
                _buildDetailRow('Nomor Rangka', vehicle.nomorRangka),
                _buildDetailRow('Nomor Mesin', vehicle.nomorMesin),
                _buildDetailRow('Warna', vehicle.warna),
              ],
            ),
            const SizedBox(height: AppSizes.p16),
            _buildSection(
              context,
              'Informasi Aset',
              [
                _buildDetailRow('Jenis Kendaraan', vehicle.jenisKendaraan),
                _buildDetailRow('Tahun Perolehan', vehicle.tahunPerolehan.toString()),
                _buildDetailRow('Nilai Aset', Formatters.formatRupiah(vehicle.nilaiAset)),
                _buildDetailRow('Sumber Dana', vehicle.sumberDana),
                _buildDetailRow('OPD Pengguna', vehicle.namaOpd),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionBadge(String kondisi) {
    Color color;
    if (kondisi == 'Baik') color = AppColors.success;
    else if (kondisi == 'Rusak Ringan') color = AppColors.warning;
    else color = AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            kondisi,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Hapus Kendaraan',
        message: 'Apakah Anda yakin ingin menghapus data kendaraan ini?',
        isDestructive: true,
      ),
    );
    if (confirm == true) {
      ref.read(vehiclesProvider.notifier).deleteVehicle(vehicle.idKendaraan);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data kendaraan berhasil dihapus')),
        );
        context.pop();
      }
    }
  }
}
