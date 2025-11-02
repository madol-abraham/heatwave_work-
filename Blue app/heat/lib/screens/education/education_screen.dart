import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/heat_app_bar.dart';
import '../../widgets/drawer_menu.dart';
import '../../core/theme/colors.dart';
import '../../services/video_service.dart';
import '../../models/video.dart';

class EducationScreen extends StatefulWidget {
  static const route = '/education';
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Video> _videos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final videos = await VideoService.searchClimateVideos();
      setState(() {
        _videos = videos;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: const HeatAppBar(title: "Climate Education"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.bg, Colors.white.withOpacity(0.8)],
          ),
        ),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'Videos', icon: Icon(Icons.play_circle)),
                Tab(text: 'Health Tips', icon: Icon(Icons.health_and_safety)),
                Tab(text: 'Climate Info', icon: Icon(Icons.info)),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVideosTab(),
                  _buildHealthTipsTab(),
                  _buildClimateInfoTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_videos.isEmpty) {
      return _buildFallbackContent();
    }

    return RefreshIndicator(
      onRefresh: _loadVideos,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return _VideoCard(video: video);
        },
      ),
    );
  }

  Widget _buildFallbackContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Icon(Icons.video_library_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Videos Temporarily Unavailable',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Educational videos are currently unavailable due to API limits. Please try again later or check the other tabs for health tips and climate information.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _loadVideos,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _Card(
          title: "Recommended Video Topics",
          body: "• Heat exhaustion prevention and treatment\n• Climate change adaptation strategies\n• Water conservation techniques\n• Emergency preparedness for extreme heat\n• Community health during heatwaves",
          icon: Icons.video_library,
        ),
      ],
    );
  }

  Widget _buildHealthTipsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Card(
          title: "Heat Exhaustion Prevention",
          body: "• Drink water every 15-20 minutes\n• Wear loose, light-colored clothing\n• Take breaks in shade or AC\n• Avoid alcohol and caffeine",
          icon: Icons.water_drop,
        ),
        _Card(
          title: "Warning Signs",
          body: "Heavy sweating • Weakness • Nausea • Headache • Muscle cramps • Dizziness. Seek immediate medical help if symptoms worsen.",
          icon: Icons.warning,
        ),
        _Card(
          title: "Emergency Response",
          body: "Move to cool area • Remove excess clothing • Apply cool water to skin • Fan the person • Give cool water if conscious",
          icon: Icons.emergency,
        ),
      ],
    );
  }

  Widget _buildClimateInfoTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Card(
          title: "What Causes Heatwaves?",
          body: "High-pressure systems trap hot air near the ground, preventing cooling. Climate change increases frequency and intensity.",
          icon: Icons.thermostat,
        ),
        _Card(
          title: "Africa's Climate Risk",
          body: "Rising temperatures, changing rainfall patterns, and extreme weather events threaten health, agriculture, and water resources.",
          icon: Icons.public,
        ),
        _Card(
          title: "Adaptation Strategies",
          body: "Early warning systems • Heat-resistant crops • Water conservation • Urban planning • Community preparedness",
          icon: Icons.eco,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _VideoCard extends StatelessWidget {
  final Video video;
  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _launchVideo(video.youtubeUrl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.channelTitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[400],
                    ),
                  ),
                  if (video.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      video.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchVideo(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Card extends StatelessWidget {
  final String title, body;
  final IconData? icon;
  const _Card({required this.title, required this.body, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
