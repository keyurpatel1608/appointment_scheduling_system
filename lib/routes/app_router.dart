// File: lib/routes/app_router.dart
// This file contains the app router configuration using GoRouter

import '../features/admin/company_settings/company_settings_screen.dart';
import '../features/admin/role_management/role_management_screen.dart';
import '../features/admin/user_management/user_management_screen.dart';
import '../features/appointment/appointment_detail_screen.dart';
import '../features/appointment/appointment_list_screen.dart';
import '../features/appointment/create_appointment_screen.dart';
import '../features/auth/forgot_password_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/calendar/calendar_screen.dart';
import '../features/dashboard/admin_dashboard_screen.dart';
import '../features/dashboard/ceo_dashboard_screen.dart';
import '../features/dashboard/employee_dashboard_screen.dart';
import '../features/dashboard/visitor_dashboard_screen.dart';
import '../features/notifications/notification_screen.dart';
import '../features/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Provider for the app router
final appRouterProvider = Provider<GoRouter>((ref) {
  // Add auth state provider to redirect users based on authentication status
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Implement authentication and permission checks here
      // This is a placeholder for the actual implementation

      // Example:
      // final isLoggedIn = authState.isLoggedIn;
      // final isOnboardingComplete = authState.isOnboardingComplete;

      // if (!isLoggedIn && state.location != '/login' &&
      //     state.location != '/register' &&
      //     state.location != '/forgot-password') {
      //   return '/login';
      // }

      // if (isLoggedIn && !isOnboardingComplete &&
      //     state.location != '/onboarding') {
      //   return '/onboarding';
      // }

      // Return null to continue with the navigation
      return null;
    },
    routes: [
      // Auth routes
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Dashboard routes based on user role
      GoRoute(
        path: '/dashboard/ceo',
        builder: (context, state) => const CEODashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/employee',
        builder: (context, state) => const EmployeeDashboardScreen(),
      ),
      GoRoute(
        path: '/dashboard/visitor',
        builder: (context, state) => const VisitorDashboardScreen(),
      ),

      // Appointment routes
      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppointmentListScreen(),
      ),
      GoRoute(
        path: '/appointments/create',
        builder: (context, state) => const CreateAppointmentScreen(),
      ),
      GoRoute(
        path: '/appointments/:id',
        builder: (context, state) {
          final appointmentId = state.pathParameters['id']!;
          return AppointmentDetailScreen(appointmentId: appointmentId);
        },
      ),

      // Calendar route
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),

      // Admin routes
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const UserManagementScreen(),
      ),
      GoRoute(
        path: '/admin/roles',
        builder: (context, state) => const RoleManagementScreen(),
      ),
      GoRoute(
        path: '/admin/company-settings',
        builder: (context, state) => const CompanySettingsScreen(),
      ),

      // Notification route
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationScreen(),
      ),

      // Profile route
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Oops! The page you are looking for does not exist.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
});
