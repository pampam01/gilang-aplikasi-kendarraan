import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/mock_repository.dart';
import '../../../models/opd_model.dart';

final opdProvider = NotifierProvider<OpdNotifier, AsyncValue<List<OpdModel>>>(() {
  return OpdNotifier();
});

class OpdNotifier extends Notifier<AsyncValue<List<OpdModel>>> {
  @override
  AsyncValue<List<OpdModel>> build() {
    Future.microtask(() => loadOpds());
    return const AsyncValue.loading();
  }

  final MockRepository _repository = MockRepository();
  List<OpdModel> _allOpds = [];
  String _searchQuery = '';

  Future<void> loadOpds() async {
    state = const AsyncValue.loading();
    try {
      _allOpds = await _repository.getOpds();
      _applySearch();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applySearch();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      state = AsyncValue.data(_allOpds);
    } else {
      var filtered = _allOpds.where((o) =>
          o.namaOpd.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          o.singkatan.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
      state = AsyncValue.data(filtered);
    }
  }

  Future<void> addOpd(OpdModel opd) async {
    await _repository.addOpd(opd);
    await loadOpds();
  }

  Future<void> updateOpd(OpdModel opd) async {
    await _repository.updateOpd(opd);
    await loadOpds();
  }

  Future<void> deleteOpd(String idOpd) async {
    await _repository.deleteOpd(idOpd);
    await loadOpds();
  }
}
