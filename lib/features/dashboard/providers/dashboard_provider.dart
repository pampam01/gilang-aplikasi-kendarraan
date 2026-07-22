import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../models/vehicle_model.dart';
import '../../../models/opd_model.dart';

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final repo = MockRepository();
  final vehicles = await repo.getVehicles();
  final opds = await repo.getOpds();

  int totalKendaraan = vehicles.length;
  int totalOpd = opds.length;
  int kondisiBaik = vehicles.where((v) => v.kondisi == 'Baik').length;
  int kondisiRusakRingan = vehicles.where((v) => v.kondisi == 'Rusak Ringan').length;
  int kondisiRusakBerat = vehicles.where((v) => v.kondisi == 'Rusak Berat').length;
  
  // Recent 5 vehicles
  final recentVehicles = vehicles.take(5).toList();

  return DashboardData(
    totalKendaraan: totalKendaraan,
    totalOpd: totalOpd,
    kondisiBaik: kondisiBaik,
    kondisiRusakRingan: kondisiRusakRingan,
    kondisiRusakBerat: kondisiRusakBerat,
    recentVehicles: recentVehicles,
  );
});

class DashboardData {
  final int totalKendaraan;
  final int totalOpd;
  final int kondisiBaik;
  final int kondisiRusakRingan;
  final int kondisiRusakBerat;
  final List<VehicleModel> recentVehicles;

  DashboardData({
    required this.totalKendaraan,
    required this.totalOpd,
    required this.kondisiBaik,
    required this.kondisiRusakRingan,
    required this.kondisiRusakBerat,
    required this.recentVehicles,
  });
}
