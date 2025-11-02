import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction.dart';

class PredictionService {
  static const String _baseUrl = 'https://harara-heat-dror.onrender.com';

  static Future<PredictionRun> getPredictions() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/predictions/latest'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PredictionRun.fromJson(data);
    } else {
      throw Exception('Failed to load predictions: ${response.statusCode}');
    }
  }

  static Future<PredictionRun> runNewPrediction() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/predictions/run'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'threshold': 0.67}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PredictionRun.fromJson(data);
    } else {
      throw Exception('Failed to run prediction: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getConnectionStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return {'status': 'online', 'latency': '${DateTime.now().millisecondsSinceEpoch}ms'};
      } else {
        return {'status': 'offline', 'error': 'Server unavailable'};
      }
    } catch (e) {
      return {'status': 'offline', 'error': 'Connection failed'};
    }
  }


}