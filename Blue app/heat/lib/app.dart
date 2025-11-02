import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'navigation/bottom_nav.dart';
import 'services/notification_service.dart';
import 'services/localization_service.dart';
import 'flutter_gen/gen_l10n/app_localizations.dart';

class HararaApp extends StatefulWidget {
  const HararaApp({super.key});

  @override
  State<HararaApp> createState() => _HararaAppState();
}

class _HararaAppState extends State<HararaApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _setupNotificationNavigation();
  }

  void _setupNotificationNavigation() {
    // Listen for notification taps and navigate to alerts screen
    // This is a simple implementation - you might want to use a more sophisticated routing solution
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocalizationService()..initialize(),
      child: Consumer<LocalizationService>(
        builder: (context, localizationService, child) {
          return MaterialApp(
            navigatorKey: _navigatorKey,
            title: 'Harara - Heatwave Prediction',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: localizationService.currentLocale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: LocalizationService.supportedLocales,
            home: const AuthWrapper(),
            routes: AppRoutes.all,
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('AuthWrapper - Connection: ${snapshot.connectionState}');
        print('AuthWrapper - Has data: ${snapshot.hasData}');
        print('AuthWrapper - User: ${snapshot.data?.email}');
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          print('AuthWrapper - Navigating to BottomNavShell');
          return const BottomNavShell();
        }
        
        print('AuthWrapper - Navigating to OnboardingScreen');
        return const OnboardingScreen();
      },
    );
  }
}
