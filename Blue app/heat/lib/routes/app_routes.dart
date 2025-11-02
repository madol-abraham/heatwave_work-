import 'package:flutter/material.dart';

// Core Screens
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registration_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/forecast/forecast_screen.dart';
import '../screens/education/education_screen.dart';
import '../screens/about/about_screen.dart';
import '../screens/alerts/alerts_history_screen.dart';
import '../screens/support/support_feedback_screen.dart';

import '../screens/settings/settings_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/admin/admin_dashboard_screen.dart';

// Add this import 👇
import '../navigation/bottom_nav.dart';

/// ---------------------------------------------------------------------------
///  AppRoutes - Centralized route registry for the Harara app
/// ---------------------------------------------------------------------------
class AppRoutes {
  static Map<String, WidgetBuilder> get all => {
        // Onboarding & Auth
        OnboardingScreen.route: (_) => const OnboardingScreen(),
        LoginScreen.route: (_) => const LoginScreen(),
        RegistrationScreen.route: (_) => const RegistrationScreen(),
        ForgotPasswordScreen.route: (_) => const ForgotPasswordScreen(),

        // Bottom Navigation Shell
        BottomNavShell.route: (_) => const BottomNavShell(),
        '/home': (_) => const BottomNavShell(),

        // Core Screens
        DashboardScreen.route: (_) => const DashboardScreen(),
        ForecastScreen.route: (_) => const ForecastScreen(),
        EducationScreen.route: (_) => const EducationScreen(),
        AboutScreen.route: (_) => const AboutScreen(),
        AlertsHistoryScreen.route: (_) => const AlertsHistoryScreen(),
        SupportFeedbackScreen.route: (_) => const SupportFeedbackScreen(),

        SettingsScreen.route: (_) => const SettingsScreen(),
        ProfileScreen.route: (_) => const ProfileScreen(),
        AdminDashboardScreen.route: (_) => const AdminDashboardScreen(),
      };
}
