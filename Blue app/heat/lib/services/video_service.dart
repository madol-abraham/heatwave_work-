import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/video.dart';

class VideoService {
  static String get _apiKey => dotenv.env['YOUTUBE_API_KEY'] ?? '';
  static const String _baseUrl = 'https://www.googleapis.com/youtube/v3';

  static Future<List<Video>> searchClimateVideos() async {
    final searchQueries = [
      'climate change heatwave Africa health tips',
      'extreme heat safety prevention',
      'heat stress health protection',
      'climate adaptation Africa',
      'heatwave survival guide',
    ];

    List<Video> allVideos = [];
    
    for (String query in searchQueries) {
      try {
        final videos = await _searchVideos(query, maxResults: 4);
        allVideos.addAll(videos);
      } catch (e) {
        print('Error searching for "$query": $e');
      }
    }

    // Remove duplicates and limit to 20 videos
    final uniqueVideos = <String, Video>{};
    for (final video in allVideos) {
      uniqueVideos[video.id] = video;
    }

    return uniqueVideos.values.take(20).toList();
  }

  static Future<List<Video>> _searchVideos(String query, {int maxResults = 5}) async {
    final url = Uri.parse(
      '$_baseUrl/search?part=snippet&q=$query&type=video&maxResults=$maxResults&key=$_apiKey&order=relevance&videoDuration=medium'
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List<dynamic>;
      
      return items.map((item) => Video.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load videos: ${response.statusCode}');
    }
  }

  static Future<List<Video>> getHealthTipsVideos() async {
    return await _searchVideos('heat exhaustion prevention health tips Africa', maxResults: 10);
  }

  static Future<List<Video>> getClimateEducationVideos() async {
    return await _searchVideos('climate change education Africa documentary', maxResults: 10);
  }
}