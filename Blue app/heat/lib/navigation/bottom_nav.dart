import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/forecast/forecast_screen.dart';
import '../screens/alerts/alerts_history_screen.dart';
import '../screens/education/education_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../widgets/drawer_menu.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';

/// ---------------------------------------------------------------------------
///  BottomNavShell - Main navigation container for Harara app
///  Controls tab switching between Dashboard, Forecast, Alerts, Education, Settings
///  + integrates Drawer menu for Profile, Support, About, Admin Panel
/// ---------------------------------------------------------------------------
class BottomNavShell extends StatefulWidget {
  static const route = '/home';
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _index = 0;

  // List of screen widgets for each bottom tab
  final _pages = const [
    DashboardScreen(),
    ForecastScreen(),
    AlertsHistoryScreen(),
    EducationScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      // Adds Drawer to all tabs
      drawer: const DrawerMenu(),

      // Dynamic AppBar (title changes with tab)


      // Keeps each tab’s state alive
      body: IndexedStack(index: _index, children: _pages),

      // Bottom Navigation Bar configuration
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.white.withOpacity(0.2),
          labelTextStyle: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600, 
                color: Colors.white,
              );
            }
            return Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500, 
              color: Colors.white.withOpacity(0.7),
            );
          }),
        ),
        child: NavigationBar(
          backgroundColor: AppColors.secondary,
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined, color: Colors.white70),
              selectedIcon: const Icon(Icons.home_rounded, color: Colors.white),
              label: l10n.dashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.show_chart_outlined, color: Colors.white70),
              selectedIcon: const Icon(Icons.show_chart_rounded, color: Colors.white),
              label: l10n.forecast,
            ),
            NavigationDestination(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white70),
              selectedIcon: const Icon(Icons.notifications_active_rounded, color: Colors.white),
              label: l10n.alerts,
            ),
            NavigationDestination(
              icon: const Icon(Icons.school_outlined, color: Colors.white70),
              selectedIcon: const Icon(Icons.school_rounded, color: Colors.white),
              label: l10n.education,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined, color: Colors.white70),
              selectedIcon: const Icon(Icons.settings_rounded, color: Colors.white),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
