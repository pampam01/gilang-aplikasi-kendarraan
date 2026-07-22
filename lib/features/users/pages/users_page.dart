import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/users_provider.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  final _searchController = TextEditingController();
  String _selectedRole = 'Semua';
  String _selectedStatus = 'Semua';

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Pengguna'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/users/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: usersState.when(
              data: (users) {
                if (users.isEmpty) return const EmptyState();
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSizes.p12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.secondary.withOpacity(0.2),
                          child: const Icon(Icons.person, color: AppColors.primary),
                        ),
                        title: Text(user.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${user.role} - ${user.statusAktif}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: AppColors.primary),
                              onPressed: () => context.push('/users/edit', extra: user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: AppColors.error),
                              onPressed: () => _confirmDelete(user.idUser),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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

  Widget _buildFilters() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppSizes.p16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari nama atau username...',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
            ),
            onChanged: (value) => ref.read(usersProvider.notifier).setSearchQuery(value),
          ),
          const SizedBox(height: AppSizes.p12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedRole,
                  decoration: const InputDecoration(isDense: true, labelText: 'Role'),
                  items: ['Semua', 'Administrator', 'Operator'].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedRole = val!);
                    ref.read(usersProvider.notifier).setFilters(_selectedRole, _selectedStatus);
                  },
                ),
              ),
              const SizedBox(width: AppSizes.p12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(isDense: true, labelText: 'Status'),
                  items: ['Semua', 'Aktif', 'Tidak Aktif'].map((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (val) {
                    setState(() => _selectedStatus = val!);
                    ref.read(usersProvider.notifier).setFilters(_selectedRole, _selectedStatus);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(String idUser) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Hapus Pengguna',
        message: 'Apakah Anda yakin ingin menghapus pengguna ini?',
        isDestructive: true,
      ),
    );
    if (confirm == true) {
      ref.read(usersProvider.notifier).deleteUser(idUser);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna berhasil dihapus')),
        );
      }
    }
  }
}
