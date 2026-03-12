import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../views/auth/login_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/bookings/bookings_screen.dart';
import '../views/workflow/workflow_screen.dart';
import 'package:flutter/material.dart';
import '../views/layout/app_layout.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: AppConstants.routeLogin,
    routes: [
      GoRoute(
        path: AppConstants.routeLogin,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.routeDashboard,
        pageBuilder: (context, state) => const NoTransitionPage(child: DashboardScreen()),
      ),
      GoRoute(
        path: AppConstants.routeBookings,
        pageBuilder: (context, state) => const NoTransitionPage(child: BookingsScreen()),
      ),
      GoRoute(
        path: AppConstants.routeWorkflow,
        builder: (context, state) => const WorkflowScreen(),
      ),
      // Dummy routes for Navigation
      GoRoute(
        path: AppConstants.routeReports,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: DefaultScreenWrapper(title: 'Reports', route: AppConstants.routeReports),
        ),
      ),
      GoRoute(
        path: AppConstants.routeSettings,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: DefaultScreenWrapper(title: 'Settings', route: AppConstants.routeSettings),
        ),
      ),
    ],
  );
}

// A simple wrapper for reports/settings since they weren't explicitly required to have full UI

class DefaultScreenWrapper extends StatelessWidget {
  final String title;
  final String route;
  
  const DefaultScreenWrapper({Key? key, required this.title, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: route,
      child: Center(
        child: Text(
          '$title (Coming Soon)',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
