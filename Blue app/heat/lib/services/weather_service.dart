import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'd275c38b55c2482aa9210553251910';
  static const String _baseUrl = 'https://api.weatherapi.com/v1';

  static Future<Map<String, dynamic>?> getCurrentWeather(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/current.json?key=$_apiKey&q=$city&aqi=yes'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching current weather: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getForecast(String city, {int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/forecast.json?key=$_apiKey&q=$city&days=$days&aqi=yes'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching forecast: $e');
      return null;
    }
  }
}