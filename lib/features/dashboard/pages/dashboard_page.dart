import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/statistic_card.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final dashboardState = ref.watch(dashboardProvider);

    return Scaffold(
      body: dashboardState.when(
        data: (data) => RefreshIndicator(
          onRefresh: () => ref.refresh(dashboardProvider.future),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.welcomeAdmin,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSizes.p4),
                Text(
                  AppStrings.welcomeSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.p24),
                _buildStatisticsGrid(context, data),
                const SizedBox(height: AppSizes.p24),
                _buildQuickMenus(context),
                const SizedBox(height: AppSizes.p24),
                _buildChartSection(context, data),
                const SizedBox(height: AppSizes.p24),
                _buildRecentVehicles(context, data),
              ],
            ),
          ),
        ),
        loading: () => const LoadingWidget(),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, DashboardData data) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.p16,
      mainAxisSpacing: AppSizes.p16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        StatisticCard(
          title: 'Total Kendaraan',
          value: data.totalKendaraan.toString(),
          icon: Icons.directions_car,
          color: AppColors.primary,
        ),
        StatisticCard(
          title: 'Total OPD',
          value: data.totalOpd.toString(),
          icon: Icons.business,
          color: AppColors.secondary,
        ),
        StatisticCard(
          title: 'Kondisi Baik',
          value: data.kondisiBaik.toString(),
          icon: Icons.check_circle,
          color: AppColors.success,
        ),
        StatisticCard(
          title: 'Perlu Perbaikan',
          value: (data.kondisiRusakRingan + data.kondisiRusakBerat).toString(),
          icon: Icons.build,
          color: AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildQuickMenus(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Cepat',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickMenuItem(
              icon: Icons.add_circle,
              label: 'Tambah\nKendaraan',
              color: AppColors.primary,
              onTap: () => context.push('/vehicles/add'),
            ),
            _QuickMenuItem(
              icon: Icons.business,
              label: 'Data OPD',
              color: AppColors.secondary,
              onTap: () => context.go('/opd'),
            ),
            _QuickMenuItem(
              icon: Icons.category,
              label: 'Klasifikasi',
              color: AppColors.accent,
              onTap: () => context.go('/classifications'),
            ),
            _QuickMenuItem(
              icon: Icons.assessment,
              label: 'Buat Laporan',
              color: AppColors.success,
              onTap: () => context.go('/reports'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartSection(BuildContext context, DashboardData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Kondisi Kendaraan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.p24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: AppColors.success,
                      value: data.kondisiBaik.toDouble(),
                      title: '${data.kondisiBaik}',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: AppColors.warning,
                      value: data.kondisiRusakRingan.toDouble(),
                      title: '${data.kondisiRusakRingan}',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: AppColors.error,
                      value: data.kondisiRusakBerat.toDouble(),
                      title: '${data.kondisiRusakBerat}',
                      radius: 50,
                      titleStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.p16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Baik', AppColors.success),
                const SizedBox(width: 16),
                _buildLegendItem('Rusak Ringan', AppColors.warning),
                const SizedBox(width: 16),
                _buildLegendItem('Rusak Berat', AppColors.error),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecentVehicles(BuildContext context, DashboardData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Kendaraan Terbaru',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/vehicles'),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.p8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.recentVehicles.length,
          itemBuilder: (context, index) {
            final vehicle = data.recentVehicles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.directions_car, color: Colors.white),
                ),
                title: Text(vehicle.nomorPolisi, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${vehicle.merek} ${vehicle.tipe} - ${vehicle.namaOpd}'),
                trailing: _buildConditionBadge(vehicle.kondisi),
              ),
            );
          },
        ),
      ],
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
}

class _QuickMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickMenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
