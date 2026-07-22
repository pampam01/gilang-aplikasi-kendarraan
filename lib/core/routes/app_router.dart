import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/splash/pages/splash_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/dashboard/pages/dashboard_page.dart';
import '../../features/users/pages/users_page.dart';
import '../../features/users/pages/user_form_page.dart';
import '../../features/opd/pages/opd_page.dart';
import '../../features/opd/pages/opd_form_page.dart';
import '../../features/opd/pages/opd_detail_page.dart';
import '../../features/vehicles/pages/vehicles_page.dart';
import '../../features/vehicles/pages/vehicle_form_page.dart';
import '../../features/vehicles/pages/vehicle_detail_page.dart';
import '../../features/classifications/pages/classifications_page.dart';
import '../../features/reports/pages/reports_page.dart';
import '../../features/reports/pages/report_preview_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../shared/widgets/main_layout.dart';
import '../../models/user_model.dart';
import '../../models/opd_model.dart';
import '../../models/vehicle_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isGoingToLogin = state.uri.path == '/login';
      final isGoingToSplash = state.uri.path == '/';

      if (!isLoggedIn && !isGoingToLogin && !isGoingToSplash) {
        return '/login';
      }

      if (isLoggedIn && (isGoingToLogin || isGoingToSplash)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UsersPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const UserFormPage(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => UserFormPage(user: state.extra as UserModel),
              ),
            ],
          ),
          GoRoute(
            path: '/opd',
            builder: (context, state) => const OpdPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const OpdFormPage(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => OpdFormPage(opd: state.extra as OpdModel),
              ),
              GoRoute(
                path: 'detail',
                builder: (context, state) => OpdDetailPage(opd: state.extra as OpdModel),
              ),
            ],
          ),
          GoRoute(
            path: '/vehicles',
            builder: (context, state) => const VehiclesPage(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (context, state) => const VehicleFormPage(),
              ),
              GoRoute(
                path: 'edit',
                builder: (context, state) => VehicleFormPage(vehicle: state.extra as VehicleModel),
              ),
              GoRoute(
                path: 'detail',
                builder: (context, state) => VehicleDetailPage(vehicle: state.extra as VehicleModel),
              ),
            ],
          ),
          GoRoute(
            path: '/classifications',
            builder: (context, state) => const ClassificationsPage(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsPage(),
            routes: [
              GoRoute(
                path: 'preview',
                builder: (context, state) => ReportPreviewPage(filters: state.extra as Map<String, dynamic>),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});
