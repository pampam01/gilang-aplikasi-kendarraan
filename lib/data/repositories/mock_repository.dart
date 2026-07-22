import '../../models/user_model.dart';
import '../../models/opd_model.dart';
import '../../models/vehicle_model.dart';
import '../mock/mock_users.dart';
import '../mock/mock_opd.dart';
import '../mock/mock_vehicles.dart';

class MockRepository {
  // Singleton
  static final MockRepository _instance = MockRepository._internal();
  factory MockRepository() => _instance;
  MockRepository._internal();

  // In-memory data
  List<UserModel> users = List.from(mockUsers);
  List<OpdModel> opds = List.from(mockOpds);
  List<VehicleModel> vehicles = List.from(mockVehicles);
  
  UserModel? currentUser;

  // Auth
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    if (username == 'admin' && password == 'admin') {
      currentUser = users.firstWhere((u) => u.username == 'admin');
      return true;
    }
    return false;
  }

  void logout() {
    currentUser = null;
  }

  // Users
  Future<List<UserModel>> getUsers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return users;
  }
  
  Future<void> addUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    users.add(user);
  }

  Future<void> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = users.indexWhere((u) => u.idUser == user.idUser);
    if (index != -1) {
      users[index] = user;
    }
  }

  Future<void> deleteUser(String idUser) async {
    await Future.delayed(const Duration(milliseconds: 500));
    users.removeWhere((u) => u.idUser == idUser);
  }

  // OPD
  Future<List<OpdModel>> getOpds() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return opds;
  }

  Future<void> addOpd(OpdModel opd) async {
    await Future.delayed(const Duration(milliseconds: 500));
    opds.add(opd);
  }

  Future<void> updateOpd(OpdModel opd) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = opds.indexWhere((o) => o.idOpd == opd.idOpd);
    if (index != -1) {
      opds[index] = opd;
    }
  }

  Future<void> deleteOpd(String idOpd) async {
    await Future.delayed(const Duration(milliseconds: 500));
    opds.removeWhere((o) => o.idOpd == idOpd);
  }

  // Vehicles
  Future<List<VehicleModel>> getVehicles() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Sort by tanggalInput descending
    final sorted = List<VehicleModel>.from(vehicles);
    sorted.sort((a, b) => b.tanggalInput.compareTo(a.tanggalInput));
    return sorted;
  }

  Future<void> addVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    vehicles.add(vehicle);
    // Update OPD vehicle count
    final opdIndex = opds.indexWhere((o) => o.namaOpd == vehicle.namaOpd);
    if (opdIndex != -1) {
      final opd = opds[opdIndex];
      opds[opdIndex] = opd.copyWith(jumlahKendaraan: opd.jumlahKendaraan + 1);
    }
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = vehicles.indexWhere((v) => v.idKendaraan == vehicle.idKendaraan);
    if (index != -1) {
      final oldOpd = vehicles[index].namaOpd;
      vehicles[index] = vehicle;
      
      if (oldOpd != vehicle.namaOpd) {
        final oldOpdIndex = opds.indexWhere((o) => o.namaOpd == oldOpd);
        if (oldOpdIndex != -1) {
          opds[oldOpdIndex] = opds[oldOpdIndex].copyWith(jumlahKendaraan: opds[oldOpdIndex].jumlahKendaraan - 1);
        }
        final newOpdIndex = opds.indexWhere((o) => o.namaOpd == vehicle.namaOpd);
        if (newOpdIndex != -1) {
          opds[newOpdIndex] = opds[newOpdIndex].copyWith(jumlahKendaraan: opds[newOpdIndex].jumlahKendaraan + 1);
        }
      }
    }
  }

  Future<void> deleteVehicle(String idKendaraan) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = vehicles.indexWhere((v) => v.idKendaraan == idKendaraan);
    if (index != -1) {
      final vehicle = vehicles[index];
      vehicles.removeAt(index);
      
      final opdIndex = opds.indexWhere((o) => o.namaOpd == vehicle.namaOpd);
      if (opdIndex != -1) {
        final opd = opds[opdIndex];
        opds[opdIndex] = opd.copyWith(jumlahKendaraan: opd.jumlahKendaraan - 1);
      }
    }
  }
}
