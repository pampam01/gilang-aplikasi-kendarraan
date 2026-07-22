import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../data/repositories/mock_repository.dart';
import '../providers/vehicles_provider.dart';

class VehiclesPage extends ConsumerStatefulWidget {
  const VehiclesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends ConsumerState<VehiclesPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vehiclesState = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kendaraan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vehicles/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari Nopol, Merek, OPD...',
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                    ),
                    onChanged: (value) => ref.read(vehiclesProvider.notifier).setSearchQuery(value),
                  ),
                ),
                const SizedBox(width: AppSizes.p8),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(vehiclesProvider.notifier).resetFilters();
                  },
                  tooltip: 'Reset Filter',
                )
              ],
            ),
          ),
          Expanded(
            child: vehiclesState.when(
              data: (vehicles) {
                if (vehicles.isEmpty) return const EmptyState();
                return RefreshIndicator(
                  onRefresh: () => ref.read(vehiclesProvider.notifier).loadVehicles(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSizes.p12),
                        child: InkWell(
                          onTap: () => context.push('/vehicles/detail', extra: vehicle),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSizes.p16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.directions_car, color: AppColors.primary),
                                        const SizedBox(width: 8),
                                        Text(
                                          vehicle.nomorPolisi,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          context.push('/vehicles/edit', extra: vehicle);
                                        } else if (value == 'delete') {
                                          _confirmDelete(vehicle.idKendaraan);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                        const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: AppColors.error))),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('${vehicle.merek} ${vehicle.tipe} (${vehicle.tahunPerolehan})'),
                                const SizedBox(height: 4),
                                Text(vehicle.namaOpd, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildConditionBadge(vehicle.kondisi),
                                    const SizedBox(width: 8),
                                    _buildStatusBadge(vehicle.statusPenggunaan),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingWidget(),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() async {
    final opds = await MockRepository().getOpds();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: AppSizes.p16,
            right: AppSizes.p16,
            top: AppSizes.p24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Filter Kendaraan', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSizes.p16),
              // Dummy filters
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Jenis Kendaraan'),
                value: 'Semua', // Should track actual state if robust, simplifed for now
                items: ['Semua', 'Mobil Penumpang', 'Mobil Barang', 'Sepeda Motor', 'Kendaraan Khusus'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) {
                  ref.read(vehiclesProvider.notifier).setFilters(jenis: val);
                },
              ),
              const SizedBox(height: AppSizes.p12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Kondisi'),
                value: 'Semua',
                items: ['Semua', 'Baik', 'Rusak Ringan', 'Rusak Berat'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) {
                  ref.read(vehiclesProvider.notifier).setFilters(kondisi: val);
                },
              ),
              const SizedBox(height: AppSizes.p12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status Penggunaan'),
                value: 'Semua',
                items: ['Semua', 'Digunakan', 'Dipinjamkan', 'Tidak Digunakan', 'Dalam Perbaikan'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (val) {
                  ref.read(vehiclesProvider.notifier).setFilters(status: val);
                },
              ),
              const SizedBox(height: AppSizes.p12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'OPD Pengguna'),
                value: 'Semua',
                items: ['Semua', ...opds.map((e) => e.namaOpd)].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis));
                }).toList(),
                onChanged: (val) {
                  ref.read(vehiclesProvider.notifier).setFilters(opd: val);
                },
              ),
              const SizedBox(height: AppSizes.p24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Terapkan Filter'),
              ),
              const SizedBox(height: AppSizes.p24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConditionBadge(String kondisi) {
    Color color;
    if (kondisi == 'Baik') color = AppColors.success;
    else if (kondisi == 'Rusak Ringan') color = AppColors.warning;
    else color = AppColors.error;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        kondisi,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _confirmDelete(String idKendaraan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Hapus Kendaraan',
        message: 'Apakah Anda yakin ingin menghapus data kendaraan ini?',
        isDestructive: true,
      ),
    );
    if (confirm == true) {
      ref.read(vehiclesProvider.notifier).deleteVehicle(idKendaraan);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data kendaraan berhasil dihapus')),
        );
      }
    }
  }
}
