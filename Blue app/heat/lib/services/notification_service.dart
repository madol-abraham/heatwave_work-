import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  StreamSubscription<QuerySnapshot>? _alertsSubscription;
  
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _selectedTownKey = 'selected_town';

  Future<void> initialize() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    await _setupFirebaseMessaging();
    _startListeningToAlerts();
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> _setupFirebaseMessaging() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    
    // Check for initial message when app is opened from terminated state
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  void _startListeningToAlerts() {
    final userId = AuthService.currentUser?.uid;
    if (userId == null) return;

    _alertsSubscription = FirebaseFirestore.instance
        .collection('alerts')
        .where('userId', isEqualTo: userId)
        .where('alert', isEqualTo: true)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen(_handleNewAlert);
  }

  Future<void> _handleNewAlert(QuerySnapshot snapshot) async {
    final isEnabled = await _areNotificationsEnabled();
    if (!isEnabled) return;

    final selectedTown = await _getSelectedTown();
    
    for (final change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        final data = change.doc.data() as Map<String, dynamic>;
        final town = data['town'] as String;
        final alertType = data['type'] as String? ?? 'prediction';
        
        // Filter by selected town if set
        if (selectedTown != null && selectedTown != 'All Towns' && town != selectedTown) {
          continue;
        }
        
        await _showLocalNotification(data, alertType);
        
        // Send FCM for manual alerts
        if (alertType == 'manual') {
          await _sendFCMNotification(data);
        }
      }
    }
  }

  Future<void> _showLocalNotification(Map<String, dynamic> alertData, [String alertType = 'prediction']) async {
    final town = alertData['town'] as String;
    final message = alertData['message'] as String;
    final severity = alertData['severity'] as String? ?? 'Moderate';
    final probability = (alertData['probability'] as num?)?.toDouble() ?? 0.0;

    final isManual = alertType == 'manual';
    final iconName = (severity.toLowerCase() == 'high' || severity.toLowerCase() == 'critical') 
        ? '@drawable/ic_alert_high' 
        : '@drawable/ic_alert_moderate';

    final androidDetails = AndroidNotificationDetails(
      'heatwave_alerts',
      'Heatwave Alerts',
      channelDescription: 'Notifications for heatwave alerts',
      importance: Importance.high,
      priority: Priority.high,
      icon: iconName,
      sound: const RawResourceAndroidNotificationSound('alert_sound'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      styleInformation: BigTextStyleInformation(
        message,
        contentTitle: isManual ? 'MANUAL ALERT' : 'HARARA HEATWAVE ALERT',
        summaryText: '$town - $severity Risk',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alert_sound.aiff',
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final title = isManual ? 'MANUAL ALERT' : 'HARARA HEATWAVE ALERT';
    final body = '$town - $severity Risk (${(probability * 100).toInt()}%)\n$message';

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: '/alerts',
    );
  }

  Future<void> _sendFCMNotification(Map<String, dynamic> alertData) async {
    try {
      final town = alertData['town'] as String;
      final message = alertData['message'] as String;
      final severity = alertData['severity'] as String? ?? 'Moderate';
      
      // Get FCM token for the current user
      final token = await _messaging.getToken();
      if (token == null) return;
      
      // Store FCM data for potential server-side sending
      await FirebaseFirestore.instance.collection('fcm_notifications').add({
        'token': token,
        'title': 'MANUAL ALERT',
        'body': '$town - $severity Risk\n$message',
        'data': {
          'type': 'manual_alert',
          'town': town,
          'severity': severity,
          'route': '/alerts',
        },
        'timestamp': FieldValue.serverTimestamp(),
        'sent': false,
      });
      
      print('FCM notification queued for manual alert');
    } catch (e) {
      print('Error sending FCM notification: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.messageId}');
    // Handle foreground message if needed
  }

  void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.messageId}');
    // Navigate to alerts screen
    _navigateToAlerts();
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload == '/alerts') {
      _navigateToAlerts();
    }
  }

  void _navigateToAlerts() {
    // Navigate to alerts screen using a simple approach
    // In a production app, you might want to use a more sophisticated routing solution
    print('Navigate to alerts screen');
  }

  // User preferences
  Future<bool> _areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  Future<String?> _getSelectedTown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedTownKey);
  }

  Future<void> setSelectedTown(String? town) async {
    final prefs = await SharedPreferences.getInstance();
    if (town != null) {
      await prefs.setString(_selectedTownKey, town);
    } else {
      await prefs.remove(_selectedTownKey);
    }
  }

  void dispose() {
    _alertsSubscription?.cancel();
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
}