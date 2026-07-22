import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../providers/opd_provider.dart';

class OpdPage extends ConsumerStatefulWidget {
  const OpdPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OpdPage> createState() => _OpdPageState();
}

class _OpdPageState extends ConsumerState<OpdPage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final opdState = ref.watch(opdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data OPD'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/opd/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(AppSizes.p16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Cari nama atau singkatan OPD...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
              onChanged: (value) => ref.read(opdProvider.notifier).setSearchQuery(value),
            ),
          ),
          Expanded(
            child: opdState.when(
              data: (opds) {
                if (opds.isEmpty) return const EmptyState();
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  itemCount: opds.length,
                  itemBuilder: (context, index) {
                    final opd = opds[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: AppSizes.p12),
                      child: ListTile(
                        onTap: () => context.push('/opd/detail', extra: opd),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.accent.withOpacity(0.2),
                          child: const Icon(Icons.business, color: AppColors.accent),
                        ),
                        title: Text(opd.namaOpd, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${opd.singkatan} • ${opd.jumlahKendaraan} Kendaraan'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              context.push('/opd/edit', extra: opd);
                            } else if (value == 'delete') {
                              _confirmDelete(opd.idOpd);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: 'edit', child: Text('Edit')),
                            const PopupMenuItem(value: 'delete', child: Text('Hapus', style: TextStyle(color: AppColors.error))),
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

  void _confirmDelete(String idOpd) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Hapus OPD',
        message: 'Apakah Anda yakin ingin menghapus data OPD ini?',
        isDestructive: true,
      ),
    );
    if (confirm == true) {
      ref.read(opdProvider.notifier).deleteOpd(idOpd);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data OPD berhasil dihapus')),
        );
      }
    }
  }
}
