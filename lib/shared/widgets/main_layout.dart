import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../features/auth/providers/auth_provider.dart';

class MainLayout extends ConsumerWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  void _onLogout(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Konfirmasi Logout',
        message: 'Apakah Anda yakin ingin keluar dari aplikasi?',
        confirmText: 'Ya, Keluar',
      ),
    );

    if (confirm == true) {
      ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: AppColors.primary, size: 40),
              ),
              accountName: Text(
                user?.nama ?? 'Administrator',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(AppStrings.institution),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/dashboard');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.people,
                    title: 'Data Pengguna',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/users');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.business,
                    title: 'Data OPD',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/opd');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.directions_car,
                    title: 'Data Kendaraan',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/vehicles');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.category,
                    title: 'Klasifikasi Kendaraan',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/classifications');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.assessment,
                    title: 'Laporan',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/reports');
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    title: 'Profil',
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/profile');
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Logout', style: TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _onLogout(context, ref);
              },
            ),
            const SizedBox(height: AppSizes.p16),
          ],
        ),
      ),
      body: SafeArea(child: child),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: onTap,
    );
  }
}
