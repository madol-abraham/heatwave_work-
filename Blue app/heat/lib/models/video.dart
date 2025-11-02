class Video {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String channelTitle;
  final String publishedAt;
  final String duration;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.channelTitle,
    required this.publishedAt,
    required this.duration,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] as Map<String, dynamic>;
    return Video(
      id: json['id']['videoId'] ?? '',
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      thumbnailUrl: snippet['thumbnails']['medium']['url'] ?? '',
      channelTitle: snippet['channelTitle'] ?? '',
      publishedAt: snippet['publishedAt'] ?? '',
      duration: '', // Will be populated separately if needed
    );
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$id';
}