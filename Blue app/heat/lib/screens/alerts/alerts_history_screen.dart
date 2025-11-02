import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/colors.dart';
import '../../services/api_service.dart';
import '../../widgets/heat_app_bar.dart';
import '../../widgets/drawer_menu.dart';

class AlertsHistoryScreen extends StatefulWidget {
  static const route = '/alerts';
  const AlertsHistoryScreen({super.key});

  @override
  State<AlertsHistoryScreen> createState() => _AlertsHistoryScreenState();
}

class _AlertsHistoryScreenState extends State<AlertsHistoryScreen> {
  String _selectedTown = 'All Towns';
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: const HeatAppBar(title: 'Alerts'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg, Colors.white],
          ),
        ),
        child: Column(
          children: [
            _buildFilterBar(),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: ApiService.getLatestAlerts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return _buildErrorState();
                  }

                  final alerts = snapshot.data ?? [];
                  final filteredAlerts = _filterAlerts(alerts);

                  if (filteredAlerts.isEmpty) {
                    return _buildEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () async => setState(() {}),
                    child: _buildAlertsList(filteredAlerts),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.filter_list, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Filter Alerts',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedTown,
                decoration: InputDecoration(
                  labelText: 'Select Town',
                  prefixIcon: const Icon(Icons.location_on, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
                  ),
                ),
                items: _towns.map((town) {
                  return DropdownMenuItem(
                    value: town,
                    child: Text(town, style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedTown = value!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsList(List<Map<String, dynamic>> alerts) {
    final groupedAlerts = _groupAlertsByTime(alerts);
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groupedAlerts.length,
      itemBuilder: (context, index) {
        final group = groupedAlerts[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupHeader(group['title']),
            ...group['alerts'].map<Widget>((alert) => _buildAlertCard(alert)),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildGroupHeader(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withOpacity(0.1), AppColors.secondary.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final town = alert['town'] ?? '';
    final message = alert['message'] ?? '';
    final probability = (alert['probability'] ?? 0.0) as double;
    final timestamp = _parseTimestamp(alert['timestamp']);
    final isRead = alert['read'] ?? false;
    final alertType = alert['type'] ?? 'prediction';
    final severity = alert['severity'] ?? 'moderate';
    final alertId = alert['id'] ?? '';

    final riskColor = _getRiskColor(probability);
    final timeAgo = _getTimeAgo(timestamp);
    final isManual = alertType == 'manual';
    final riskLevel = probability >= 0.8 ? 'Extreme' : probability >= 0.6 ? 'High' : probability >= 0.4 ? 'Moderate' : 'Low';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Dismissible(
        key: Key(alertId),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isRead ? 'Mark Unread' : 'Mark Read',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.red.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await _toggleReadStatus(alertId, isRead);
            return false;
          } else {
            return await _showDeleteConfirmation(context, town);
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            _deleteAlert(alertId);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: isRead ? Colors.grey.withOpacity(0.3) : riskColor,
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _markAsRead(alertId),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isManual ? Icons.campaign : Icons.warning_rounded,
                          color: riskColor,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      town,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                                        color: isRead ? Colors.grey : AppColors.text,
                                      ),
                                    ),
                                  ),
                                  if (isManual) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'MANUAL',
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isManual ? 'Risk: ${severity.toUpperCase()}' : 'Risk: $riskLevel',
                                style: TextStyle(
                                  color: riskColor.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          isManual ? severity.toUpperCase() : '${(probability * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: riskColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isRead ? Colors.grey : AppColors.text,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const Spacer(),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: riskColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _groupAlertsByTime(List<Map<String, dynamic>> alerts) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(const Duration(days: 7));

    final todayAlerts = <Map<String, dynamic>>[];
    final yesterdayAlerts = <Map<String, dynamic>>[];
    final thisWeekAlerts = <Map<String, dynamic>>[];
    final olderAlerts = <Map<String, dynamic>>[];

    for (final alert in alerts) {
      final timestamp = _parseTimestamp(alert['timestamp']);
      final alertDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

      if (alertDate == today) {
        todayAlerts.add(alert);
      } else if (alertDate == yesterday) {
        yesterdayAlerts.add(alert);
      } else if (alertDate.isAfter(thisWeek)) {
        thisWeekAlerts.add(alert);
      } else {
        olderAlerts.add(alert);
      }
    }

    final groups = <Map<String, dynamic>>[];
    if (todayAlerts.isNotEmpty) {
      groups.add({'title': 'Today', 'alerts': todayAlerts});
    }
    if (yesterdayAlerts.isNotEmpty) {
      groups.add({'title': 'Yesterday', 'alerts': yesterdayAlerts});
    }
    if (thisWeekAlerts.isNotEmpty) {
      groups.add({'title': 'This Week', 'alerts': thisWeekAlerts});
    }
    if (olderAlerts.isNotEmpty) {
      groups.add({'title': 'Older', 'alerts': olderAlerts});
    }

    return groups;
  }

  List<Map<String, dynamic>> _filterAlerts(List<Map<String, dynamic>> alerts) {
    if (_selectedTown == 'All Towns') return alerts;
    return alerts.where((alert) {
      final alertTown = alert['town'] ?? '';
      return alertTown == _selectedTown || alertTown == 'All Towns';
    }).toList();
  }

  Color _getRiskColor(double probability) {
    if (probability >= 0.8) return AppColors.extremeRisk;
    if (probability >= 0.6) return AppColors.highRisk;
    if (probability >= 0.4) return AppColors.moderateRisk;
    return AppColors.lowRisk;
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _toggleReadStatus(String alertId, bool currentStatus) async {
    // API endpoint would handle read status updates
    setState(() {});
  }

  Future<bool> _showDeleteConfirmation(BuildContext context, String town) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: Text('Delete alert for $town?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _deleteAlert(String alertId) async {
    // API endpoint would handle alert deletion
    setState(() {});
  }

  Future<void> _markAsRead(String alertId) async {
    // API endpoint would handle marking as read
    setState(() {});
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary.withOpacity(0.05), Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 48,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Alerts Yet',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You\'ll see heatwave alerts and notifications here when they become available.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.withOpacity(0.05), Colors.white],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Connection Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Unable to load alerts. Please check your internet connection.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    
    if (timestamp is Map<String, dynamic>) {
      // Firestore timestamp format
      final seconds = timestamp['_seconds'] ?? 0;
      final nanoseconds = timestamp['_nanoseconds'] ?? 0;
      return DateTime.fromMillisecondsSinceEpoch(
        seconds * 1000 + (nanoseconds / 1000000).round(),
      );
    }
    
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    
    return DateTime.now();
  }
}