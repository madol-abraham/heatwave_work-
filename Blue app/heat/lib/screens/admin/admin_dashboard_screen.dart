import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../services/admin_service.dart';
import '../../widgets/heat_app_bar.dart';

class AdminDashboardScreen extends StatefulWidget {
  static const route = '/admin';
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  
  String _severity = 'moderate';
  String _targetType = 'all';
  String? _targetValue;
  bool _sendSMS = true;
  bool _sendPush = true;
  bool _loading = false;
  
  final List<String> _towns = ['Juba', 'Wau', 'Yambio', 'Bor', 'Malakal', 'Bentiu'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HeatAppBar(title: 'Admin Dashboard', showDrawer: false),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg, Colors.white.withOpacity(0.8)],
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.white, AppColors.bg.withOpacity(0.5)],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.admin_panel_settings, color: AppColors.primary, size: 28),
                          const SizedBox(width: 12),
                          Text('Send Manual Alert', 
                               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                 color: AppColors.primary,
                                 fontWeight: FontWeight.bold,
                               )),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      TextFormField(
                        controller: _messageController,
                        maxLines: 6,
                        maxLength: 280,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Alert Message',
                          hintText: 'Enter alert message',
                          prefixIcon: Icon(Icons.message, color: AppColors.primary),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Message required' : null,
                      ),
                      
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _severity,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Severity Level',
                          prefixIcon: Icon(Icons.warning, color: AppColors.primary),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'low', child: Text('🟢 Low')),
                          DropdownMenuItem(value: 'moderate', child: Text('🟡 Moderate')),
                          DropdownMenuItem(value: 'high', child: Text('🟠 High')),
                          DropdownMenuItem(value: 'critical', child: Text('🔴 Critical')),
                        ],
                        onChanged: (v) => setState(() => _severity = v!),
                      ),
                      
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _targetType,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Send To',
                          prefixIcon: Icon(Icons.people, color: AppColors.primary),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('👥 All Users')),
                          DropdownMenuItem(value: 'town', child: Text('🏘️ Specific Town')),
                        ],
                        onChanged: (v) => setState(() {
                          _targetType = v!;
                          _targetValue = null;
                        }),
                      ),
                      
                      if (_targetType == 'town') ...[
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: _targetValue,
                          style: Theme.of(context).textTheme.bodyLarge,
                          decoration: InputDecoration(
                            labelText: 'Select Town',
                            prefixIcon: Icon(Icons.location_city, color: AppColors.primary),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
                            ),
                          ),
                          items: _towns.map((town) => DropdownMenuItem(
                            value: town,
                            child: Text('📍 $town'),
                          )).toList(),
                          onChanged: (v) => setState(() => _targetValue = v),
                          validator: (v) => v == null ? 'Select town' : null,
                        ),
                      ],
                      
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.bg.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery Methods:', 
                                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                   color: AppColors.primary,
                                   fontWeight: FontWeight.w600,
                                 )),
                            const SizedBox(height: 8),
                            CheckboxListTile(
                              title: const Text('📱 Send Push Notification'),
                              subtitle: const Text('In-app notification'),
                              value: _sendPush,
                              activeColor: AppColors.primary,
                              onChanged: (v) => setState(() => _sendPush = v!),
                              contentPadding: EdgeInsets.zero,
                            ),
                            CheckboxListTile(
                              title: const Text('📨 Send SMS'),
                              subtitle: const Text('Text message via Africa\'s Talking + Alerts screen'),
                              value: _sendSMS,
                              activeColor: AppColors.primary,
                              onChanged: (v) => setState(() => _sendSMS = v!),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
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
                        child: ElevatedButton.icon(
                          onPressed: _loading ? null : _sendAlert,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send, color: Colors.white),
                          label: Text(
                            _loading ? 'Sending Alert...' : 'Send Alert',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendAlert() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_sendSMS && !_sendPush) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Select at least one delivery method'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await AdminService.sendManualAlert(
        message: _messageController.text.trim(),
        severity: _severity,
        targetType: _targetType,
        targetValue: _targetValue,
        sendSMS: _sendSMS,
        sendPush: _sendPush,
      );

      if (mounted) {
        final targetText = _targetType == 'all' ? 'all users' : _targetValue;
        final methodText = _sendSMS && _sendPush ? 'SMS & Push notifications' : 
                         _sendSMS ? 'SMS messages' : 'Push notifications';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Manual alert sent to $targetText via $methodText!\nUsers will see this in their Alerts screen.',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 6),
          ),
        );
        _messageController.clear();
        setState(() {
          _severity = 'moderate';
          _targetType = 'all';
          _targetValue = null;
          _sendSMS = true;
          _sendPush = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Failed to send alert: $e',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: AppColors.danger,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

//AIzaSyDAkO7ebuqSN9ushzGuS8cQQ-8wjXapCGQ #google APII for EducationH