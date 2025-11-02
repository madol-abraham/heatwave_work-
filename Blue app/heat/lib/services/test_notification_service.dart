import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class TestNotificationService {
  static Future<void> createTestAlert({
    required String town,
    required String message,
    required String severity,
    required double probability,
  }) async {
    final userId = AuthService.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('alerts').add({
        'userId': userId,
        'town': town,
        'message': message,
        'severity': severity,
        'probability': probability,
        'timestamp': Timestamp.now(),
        'alert': true,
        'read': false,
      });
      
      print('Test alert created for $town');
    } catch (e) {
      print('Error creating test alert: $e');
    }
  }

  static Future<void> createSampleAlerts() async {
    final alerts = [
      {
        'town': 'Juba',
        'message': 'Extreme heatwave warning - temperatures may reach 45°C',
        'severity': 'High',
        'probability': 0.92,
      },
      {
        'town': 'Wau',
        'message': 'Moderate heat risk detected - stay hydrated',
        'severity': 'Moderate', 
        'probability': 0.68,
      },
      {
        'town': 'Yambio',
        'message': 'High temperature alert - avoid outdoor activities',
        'severity': 'High',
        'probability': 0.85,
      },
    ];

    for (final alert in alerts) {
      await createTestAlert(
        town: alert['town'] as String,
        message: alert['message'] as String,
        severity: alert['severity'] as String,
        probability: alert['probability'] as double,
      );
      
      // Add delay between alerts
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}