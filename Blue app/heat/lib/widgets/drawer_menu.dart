import 'dart:convert';
import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';

/// ---------------------------------------------------------------------------
/// DrawerMenu - Sidebar navigation for Profile, About, Support, and Admin Panel
/// ---------------------------------------------------------------------------
class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  Map<String, dynamic>? _userData;
  bool _loading = true;

  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkAdminStatus();
  }

  Future<void> _loadUserData() async {
    try {
      final data = await AuthService.getUserData();
      setState(() {
        _userData = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _checkAdminStatus() async {
    final isAdmin = await AdminService.isAdmin();
    setState(() => _isAdmin = isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final name = _userData?['name'] ?? user?.displayName ?? 'User';
    final location = _userData?['location'] ?? 'Location not set';
    final photoURL = _userData?['photoURL'] ?? user?.photoURL;
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with gradient background
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage: photoURL != null 
                      ? (photoURL.startsWith('data:image') 
                          ? MemoryImage(base64Decode(photoURL.split(',')[1]))
                          : NetworkImage(photoURL)) as ImageProvider
                      : null,
                  child: photoURL == null
                      ? const Icon(Icons.person, color: AppColors.primary, size: 36)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800)),
                Text(location, 
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
              ],
            ),
          ),

          // Drawer links
          _DrawerTile(
            icon: Icons.account_circle_outlined,
            title: "Profile",
            route: '/profile',
          ),
          _DrawerTile(
            icon: Icons.info_outline,
            title: "About Harara",
            route: '/about',
          ),
          _DrawerTile(
            icon: Icons.chat_bubble_outline,
            title: "Support & Feedback",
            route: '/support-feedback',
          ),

          if (_isAdmin) ...<Widget>[
            const Divider(),
            _DrawerTile(
              icon: Icons.admin_panel_settings,
              title: "Admin Dashboard",
              route: '/admin',
              color: Colors.orange,
            ),
          ],

          const Divider(),
          _DrawerTile(
            icon: Icons.logout,
            title: "Log Out",
            route: '/onboarding', // navigate back to onboarding (for demo)
            color: AppColors.danger,
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;
  final Color? color;
  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.route,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: color ?? AppColors.text,
              fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.pop(context); // close drawer first
        Navigator.pushNamed(context, route);
      },
    );
  }
}
