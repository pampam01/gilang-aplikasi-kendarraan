import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../models/user_model.dart';

final usersProvider = NotifierProvider<UsersNotifier, AsyncValue<List<UserModel>>>(() {
  return UsersNotifier();
});

class UsersNotifier extends Notifier<AsyncValue<List<UserModel>>> {
  @override
  AsyncValue<List<UserModel>> build() {
    // Cannot use loadUsers() directly in build if it modifies state.
    // Riverpod allows state modification only outside build or using future.
    Future.microtask(() => loadUsers());
    return const AsyncValue.loading();
  }

  final MockRepository _repository = MockRepository();
  List<UserModel> _allUsers = [];
  String _searchQuery = '';
  String _roleFilter = 'Semua';
  String _statusFilter = 'Semua';

  Future<void> loadUsers() async {
    state = const AsyncValue.loading();
    try {
      _allUsers = await _repository.getUsers();
      _applyFilters();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setFilters(String role, String status) {
    _roleFilter = role;
    _statusFilter = status;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = _allUsers.where((u) {
      final matchesSearch = u.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                            u.username.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesRole = _roleFilter == 'Semua' || u.role == _roleFilter;
      final matchesStatus = _statusFilter == 'Semua' || u.statusAktif == _statusFilter;
      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
    
    state = AsyncValue.data(filtered);
  }

  Future<void> addUser(UserModel user) async {
    await _repository.addUser(user);
    await loadUsers();
  }

  Future<void> updateUser(UserModel user) async {
    await _repository.updateUser(user);
    await loadUsers();
  }

  Future<void> deleteUser(String idUser) async {
    await _repository.deleteUser(idUser);
    await loadUsers();
  }
}
