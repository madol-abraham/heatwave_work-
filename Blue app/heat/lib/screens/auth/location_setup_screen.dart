import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/colors.dart';
import '../../services/auth_service.dart';
import '../../services/location_service.dart';
import '../../widgets/app_logo.dart';

class LocationSetupScreen extends StatefulWidget {
  final User user;
  final VoidCallback onComplete;

  const LocationSetupScreen({
    super.key,
    required this.user,
    required this.onComplete,
  });

  @override
  State<LocationSetupScreen> createState() => _LocationSetupScreenState();
}

class _LocationSetupScreenState extends State<LocationSetupScreen> {
  String? _selectedTown;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg, Colors.white.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Center(child: AppLogo(size: 50)),
                const SizedBox(height: 24),
                Text(
                  'Welcome ${widget.user.displayName?.split(' ').first ?? 'User'}!',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Please select your town to receive personalized heat alerts',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.text.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                LocationService.buildTownDropdown(
                  selectedTown: _selectedTown,
                  onChanged: (value) {
                    setState(() => _selectedTown = value);
                  },
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _selectedTown == null || _loading ? null : _saveLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Continue',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const Spacer(),
                Text(
                  'You can change this later in Settings',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.text.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveLocation() async {
    if (_selectedTown == null) return;

    setState(() => _loading = true);
    try {
      await AuthService.updateUserData({
        'location': _selectedTown!,
        'phone': '', // Default empty phone for Google users
      });
      widget.onComplete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save location: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    setState(() => _loading = false);
  }
}