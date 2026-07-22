import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../models/vehicle_model.dart';
import '../../../models/opd_model.dart';

final vehiclesProvider = NotifierProvider<VehiclesNotifier, AsyncValue<List<VehicleModel>>>(() {
  return VehiclesNotifier();
});

class VehiclesNotifier extends Notifier<AsyncValue<List<VehicleModel>>> {
  @override
  AsyncValue<List<VehicleModel>> build() {
    Future.microtask(() => loadVehicles());
    return const AsyncValue.loading();
  }

  final MockRepository _repository = MockRepository();
  List<VehicleModel> _allVehicles = [];
  
  String _searchQuery = '';
  String _jenisFilter = 'Semua';
  String _kondisiFilter = 'Semua';
  String _statusFilter = 'Semua';
  String _opdFilter = 'Semua';

  Future<void> loadVehicles() async {
    state = const AsyncValue.loading();
    try {
      _allVehicles = await _repository.getVehicles();
      _applyFilters();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setFilters({
    String? jenis,
    String? kondisi,
    String? status,
    String? opd,
  }) {
    if (jenis != null) _jenisFilter = jenis;
    if (kondisi != null) _kondisiFilter = kondisi;
    if (status != null) _statusFilter = status;
    if (opd != null) _opdFilter = opd;
    _applyFilters();
  }

  void resetFilters() {
    _searchQuery = '';
    _jenisFilter = 'Semua';
    _kondisiFilter = 'Semua';
    _statusFilter = 'Semua';
    _opdFilter = 'Semua';
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = _allVehicles.where((v) {
      final matchesSearch = _searchQuery.isEmpty ||
          v.nomorPolisi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.merek.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.tipe.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.namaOpd.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesJenis = _jenisFilter == 'Semua' || v.jenisKendaraan == _jenisFilter;
      final matchesKondisi = _kondisiFilter == 'Semua' || v.kondisi == _kondisiFilter;
      final matchesStatus = _statusFilter == 'Semua' || v.statusPenggunaan == _statusFilter;
      final matchesOpd = _opdFilter == 'Semua' || v.namaOpd == _opdFilter;

      return matchesSearch && matchesJenis && matchesKondisi && matchesStatus && matchesOpd;
    }).toList();
    
    state = AsyncValue.data(filtered);
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    await _repository.addVehicle(vehicle);
    await loadVehicles();
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    await _repository.updateVehicle(vehicle);
    await loadVehicles();
  }

  Future<void> deleteVehicle(String id) async {
    await _repository.deleteVehicle(id);
    await loadVehicles();
  }
}
