import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prediction.dart';
import 'auth_service.dart';

/// ---------------------------------------------------------------------------
/// ApiService - Comprehensive API integration for heatwave predictions
/// ---------------------------------------------------------------------------
class ApiService {
  static const String _baseUrl = 'https://harara-heat-dror.onrender.com';
  static const Duration _timeout = Duration(seconds: 30);

  /// Get the latest predictions from the API
  static Future<PredictionRun?> getLatestPredictions() async {
    try {
      print('Making API request to: $_baseUrl/predictions/today');
      final response = await http.get(
        Uri.parse('$_baseUrl/predictions/today'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      print('API Response Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('API Response Data: $data');
        return _parsePredictionRun(data);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Network Error Details: $e');
      return null;
    }
  }

  /// Trigger a new prediction run
  static Future<PredictionRun?> runPrediction() async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/predict/run'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _parsePredictionRun(data);
      } else {
        print('Prediction API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Prediction Network Error: $e');
      return null;
    }
  }

  /// Get API health status
  static Future<bool> checkApiHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      print('Health Check Error: $e');
      return false;
    }
  }

  /// Parse API response into PredictionRun model
  static PredictionRun _parsePredictionRun(Map<String, dynamic> data) {
    final predictions = (data['predictions'] as List)
        .map((p) => Prediction(
              town: p['town'] as String,
              probability: (p['probability'] as num).toDouble(),
              alert: p['alert'] == 1,
            ))
        .toList();

    return PredictionRun(
      runTs: DateTime.parse(data['run_ts'] as String),
      startDate: DateTime.parse(data['start_date'] as String),
      endDate: DateTime.parse(data['end_date'] as String),
      threshold: (data['threshold'] as num?)?.toDouble() ?? 0.5,
      predictions: predictions,
    );
  }

  /// Firebase integration methods
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<Map<String, dynamic>>> getAlerts() async {
    try {
      final userId = AuthService.currentUser?.uid;
      if (userId != null) {
        final snapshot = await _firestore
            .collection('alerts')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .limit(50)
            .get();
        
        return snapshot.docs.map((doc) => {
          'id': doc.id,
          ...doc.data(),
        }).toList();
      }
    } catch (e) {
      print('Failed to get alerts: $e');
    }
    return [];
  }

  static Future<void> saveAlert(Map<String, dynamic> alert) async {
    try {
      await _firestore.collection('alerts').add({
        ...alert,
        'userId': AuthService.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to save alert: $e');
    }
  }

  static Future<void> sendFeedback(String message, int rating) async {
    try {
      await _firestore.collection('feedback').add({
        'message': message,
        'rating': rating,
        'userId': AuthService.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to send feedback: $e');
    }
  }

  /// Get latest alerts from FastAPI endpoint
  static Future<List<Map<String, dynamic>>> getLatestAlerts() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/firestore/alerts/latest'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['latest_alerts'] != null) {
          return List<Map<String, dynamic>>.from(data['latest_alerts']);
        }
      }
    } catch (e) {
      print('Failed to get latest alerts: $e');
    }
    return [];
  }

}
