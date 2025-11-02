import 'package:flutter/material.dart';
import '../../widgets/heat_app_bar.dart';
import '../../widgets/drawer_menu.dart';
import '../../widgets/language_selector.dart';
import '../../services/notification_service.dart';
import '../../core/theme/colors.dart';
import '../../flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  static const route = '/settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _smsEnabled = true;
  bool _pushEnabled = true;
  String? _selectedTown;
  
  final List<String> _towns = [
    'All Towns',
    'Juba',
    'Bor', 
    'Malakal',
    'Wau',
    'Yambio',
    'Bentiu'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    // Load notification preferences
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushEnabled = prefs.getBool('notifications_enabled') ?? true;
      _selectedTown = prefs.getString('selected_town') ?? 'All Towns';
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: HeatAppBar(title: l10n.settings),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg, Colors.white],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNotificationSection(),
            const SizedBox(height: 24),
            _buildLocationSection(),
            const SizedBox(height: 24),
            _buildLanguageSection(),
            const SizedBox(height: 24),
            _buildOtherSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              l10n.notifications,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          SwitchListTile(
            value: _pushEnabled,
            onChanged: _togglePushNotifications,
            title: const Text('Push Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: const Text('Receive heatwave alerts', style: TextStyle(fontSize: 14, color: Colors.grey)),
            secondary: const Icon(Icons.notifications, color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          ),
          SwitchListTile(
            value: _smsEnabled,
            onChanged: (v) => setState(() => _smsEnabled = v),
            title: const Text('SMS Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: const Text('Text message alerts', style: TextStyle(fontSize: 14, color: Colors.grey)),
            secondary: const Icon(Icons.sms, color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Location Preferences',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on, color: AppColors.primary),
            title: const Text('Notification Town', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            subtitle: Text(_selectedTown ?? 'All Towns', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            onTap: _showTownPicker,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return const LanguageSelector();
  }

  Widget _buildOtherSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              l10n.about,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppColors.primary),
            title: const Text('Privacy & Terms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info, color: AppColors.primary),
            title: const Text('About Harara', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            onTap: () {},
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _togglePushNotifications(bool enabled) async {
    setState(() => _pushEnabled = enabled);
    await NotificationService().setNotificationsEnabled(enabled);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(enabled ? 'Notifications enabled' : 'Notifications disabled'),
          backgroundColor: enabled ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  Future<void> _showTownPicker() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Town for Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _towns.length,
            itemBuilder: (context, index) {
              final town = _towns[index];
              return RadioListTile<String>(
                value: town,
                groupValue: _selectedTown,
                title: Text(town),
                onChanged: (value) => Navigator.pop(context, value),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selected != null) {
      setState(() => _selectedTown = selected);
      await NotificationService().setSelectedTown(selected);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification town set to $selected'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }


}
