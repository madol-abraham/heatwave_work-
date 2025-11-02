import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/theme/colors.dart';
import '../../widgets/heat_app_bar.dart';
import '../../widgets/drawer_menu.dart';
import '../../models/prediction.dart';
import '../../services/api_service.dart';
import '../../services/weather_service.dart';

class ForecastScreen extends StatefulWidget {
  static const route = '/forecast';
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PredictionRun? _forecastData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadForecast();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadForecast() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ApiService.getLatestPredictions();
      if (result != null) {
        setState(() {
          _forecastData = result;
        });
      } else {
        setState(() {
          _error = 'No forecast data available from API.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load forecast: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getRiskColor(double probability) {
    if (probability >= 0.8) return Colors.red;
    if (probability >= 0.7) return Colors.orange;
    if (probability >= 0.67) return Colors.yellow[700]!;
    return Colors.green;
  }

  String _getRiskLevel(double probability) {
    if (probability >= 0.8) return 'Extreme';
    if (probability >= 0.7) return 'High';
    if (probability >= 0.67) return 'Moderate';
    return 'Low';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerMenu(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(112),
        child: AppBar(
          title: Text(
            'Forecast',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, 
              color: Colors.white,
            ),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.analytics), text: 'AI Predictions'),
              Tab(icon: Icon(Icons.wb_sunny), text: 'Weather'),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAIPredictionsTab(),
          _buildWeatherTab(),
        ],
      ),
    );
  }

  Widget _buildAIPredictionsTab() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bg, Colors.white],
        ),
      ),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _fetchPredictionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildPredictionsError();
          }

          final data = snapshot.data;
          if (data == null || data['records'] == null) {
            return _buildNoPredictions();
          }

          return RefreshIndicator(
            onRefresh: () async => setState(() {}),
            child: _buildPredictionsList(data),
          );
        },
      ),
    );
  }

  Widget _buildWeatherTab() {
    return const WeatherView();
  }

  Widget _buildHeaderCard() {
    final alertCount = _forecastData!.predictions.where((p) => p.alert).length;
    final start = _forecastData!.startDate;
    final end = _forecastData!.endDate;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "AI Heatwave Forecast Summary",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white, 
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "$alertCount high-risk regions detected\n"
            "Forecast period: ${_fmt(start)} → ${_fmt(end)}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTownCard(Prediction p) {
    final color = _getRiskColor(p.probability);
    final risk = _getRiskLevel(p.probability);
    final percent = (p.probability * 100).toStringAsFixed(1);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.wb_sunny, color: color, size: 28),
        title: Text(
          p.town,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Risk: $risk",
          style: TextStyle(color: color.withOpacity(0.9), fontWeight: FontWeight.w500),
        ),
        trailing: Text(
          "$percent%",
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 12),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadForecast,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            const Text(
              "No Forecast Available",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please check your connection or try again later.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Future<Map<String, dynamic>?> _fetchPredictionHistory() async {
    try {
      final response = await http.get(
        Uri.parse('https://harara-heat-dror.onrender.com/firestore/history/7'),
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching prediction history: $e');
      return null;
    }
  }

  Widget _buildPredictionsList(Map<String, dynamic> data) {
    final records = data['records'] as Map<String, dynamic>;
    final dates = records.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: dates.length,
      itemBuilder: (context, index) {
        final date = dates[index];
        final predictions = records[date] as List;
        return _buildDateGroup(date, predictions);
      },
    );
  }

  Widget _buildDateGroup(String date, List predictions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            _formatDate(date),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
        ...predictions.map((prediction) => _buildPredictionCard(prediction)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPredictionCard(Map<String, dynamic> prediction) {
    final town = prediction['town'] ?? 'Unknown';
    final probability = (prediction['probability'] ?? 0.0) as double;
    final riskColor = _getRiskColor(probability);
    final riskLevel = _getRiskLevel(probability);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border(
          left: BorderSide(color: riskColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.analytics, color: riskColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    town,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Risk: $riskLevel',
                    style: TextStyle(
                      color: riskColor.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${(probability * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: riskColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);
      
      if (dateOnly == today) return 'Today';
      if (dateOnly == yesterday) return 'Yesterday';
      
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildPredictionsError() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          SizedBox(height: 16),
          Text('Failed to load predictions'),
        ],
      ),
    );
  }

  Widget _buildNoPredictions() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No Predictions Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }


}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  String _selectedCity = 'Juba';
  final List<String> _cities = ['Juba', 'Bor', 'Malakal', 'Wau', 'Yambio', 'Bentiu'];
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final data = await WeatherService.getForecast(_selectedCity);
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bg, Colors.white],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: InputDecoration(
                labelText: 'Select City',
                prefixIcon: const Icon(Icons.location_city, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: _cities.map((city) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCity = value!);
                _loadWeather();
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorView()
                    : _weatherData == null
                        ? _buildNoDataView()
                        : RefreshIndicator(
                            onRefresh: _loadWeather,
                            child: _buildWeatherContent(),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCurrentWeather(),
        const SizedBox(height: 16),
        _buildForecastList(),
      ],
    );
  }

  Widget _buildCurrentWeather() {
    final current = _weatherData!['current'];
    final location = _weatherData!['location'];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            location['name'] ?? _selectedCity,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${current['temp_c']?.round() ?? 0}°C',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w300,
            ),
          ),
          Text(
            current['condition']?['text'] ?? 'N/A',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherStat('Feels like', '${current['feelslike_c']?.round() ?? 0}°C'),
              _buildWeatherStat('Humidity', '${current['humidity'] ?? 0}%'),
              _buildWeatherStat('Wind', '${current['wind_kph']?.round() ?? 0} km/h'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastList() {
    final forecast = _weatherData!['forecast']?['forecastday'] as List?;
    
    if (forecast == null || forecast.isEmpty) {
      return const Center(child: Text('No forecast data available'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '7-Day Forecast',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 12),
        ...forecast.take(7).map((day) => _buildForecastCard(day)),
      ],
    );
  }

  Widget _buildForecastCard(Map<String, dynamic> day) {
    final date = DateTime.tryParse(day['date'] ?? '') ?? DateTime.now();
    final dayData = day['day'] ?? {};
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(date),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  dayData['condition']?['text'] ?? 'N/A',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${dayData['maxtemp_c']?.round() ?? 0}°/${dayData['mintemp_c']?.round() ?? 0}°',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${dayData['maxwind_kph']?.round() ?? 0} km/h',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';
    
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Weather data unavailable',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWeather,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataView() {
    return const Center(
      child: Text(
        'No weather data available',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
}


