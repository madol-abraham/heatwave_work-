import 'package:flutter/material.dart';
import '../../models/prediction.dart';
import '../../widgets/probability_bar.dart';
import '../../widgets/connection_status.dart';
import '../../widgets/heat_app_bar.dart';
import '../../widgets/drawer_menu.dart';
import '../../core/theme/colors.dart';
import '../../services/api_service.dart';
import '../../services/test_notification_service.dart';

class DashboardScreen extends StatefulWidget {
  static const route = '/dashboard';
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PredictionRun? _currentRun;
  bool _isLoading = true;
  bool _isRunningPrediction = false;
  String? _errorMessage;


  @override
  void initState() {
    super.initState();
    _loadPredictions();
  }

  Future<void> _loadPredictions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Attempting to fetch predictions from API...');
      final predictions = await ApiService.getLatestPredictions();
      if (predictions != null) {
        print('Successfully received API data');
        setState(() {
          _currentRun = predictions;
          _isLoading = false;
        });
      } else {
        print('API returned null - no data available');
        setState(() {
          _currentRun = null;
          _errorMessage = 'No prediction data available from server';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('API error: $e');
      setState(() {
        _currentRun = null;
        _errorMessage = 'Failed to connect to prediction server: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _runNewPrediction() async {
    setState(() {
      _isRunningPrediction = true;
      _errorMessage = null;
    });

    try {
      final newRun = await ApiService.runPrediction();
      if (newRun != null) {
        setState(() {
          _currentRun = newRun;
          _isRunningPrediction = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Prediction completed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to run prediction - server returned no data';
          _isRunningPrediction = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to run prediction'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isRunningPrediction = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const DrawerMenu(),
      extendBodyBehindAppBar: true,
      appBar: HeatAppBar(
        title: 'Dashboard',
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              tooltip: 'Test Notifications',
              onPressed: () => TestNotificationService.createSampleAlerts(),
              icon: const Icon(Icons.notifications_active, color: Colors.orange),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              tooltip: 'Refresh',
              onPressed: _loadPredictions,
              icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              cs.background,
              Colors.white.withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, AppBar().preferredSize.height + 50, 20, 100),
          children: [
            if (_currentRun != null) _HeaderCard(run: _currentRun!),
            const SizedBox(height: 32),
            Row(
              children: [
                Icon(Icons.location_city, color: cs.onSurface, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Regional Risk Assessment',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              _ErrorCard(message: _errorMessage!, onRetry: _loadPredictions)
            else if (_currentRun != null)
              ..._currentRun!.predictions.map((p) => _TownCard(run: _currentRun!, p: p))
            else
              const _EmptyStateCard(),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [cs.primary, cs.secondary],
          ),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          onPressed: _isRunningPrediction ? null : _runNewPrediction,
          icon: _isRunningPrediction 
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.play_arrow_rounded),
          label: Text(
            _isRunningPrediction ? 'Running...' : 'Run Prediction',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final PredictionRun run;
  const _HeaderCard({required this.run});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final alertCount = run.predictions.where((p) => p.alert).length;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary,
            cs.secondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.thermostat, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Climate Monitor',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Live Prediction System',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.date_range, color: Colors.white.withOpacity(0.9), size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Forecast Period',
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_fmt(run.startDate)} → ${_fmt(run.endDate)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '$alertCount',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Active Alerts',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${(run.threshold * 100).toStringAsFixed(0)}%',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Alert Threshold',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _TownCard extends StatelessWidget {
  final PredictionRun run;
  final Prediction p;
  const _TownCard({required this.run, required this.p});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isHighRisk = p.alert;
    final riskLevel = p.probability >= 0.8 ? 'Extreme' : p.probability >= 0.7 ? 'High' : p.probability >= 0.67 ? 'Moderate' : 'Low';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: isHighRisk ? Border.all(color: cs.error.withOpacity(0.3), width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: isHighRisk ? cs.error.withOpacity(0.1) : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
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
                        color: isHighRisk ? cs.error.withOpacity(0.1) : cs.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.location_city,
                        color: isHighRisk ? cs.error : cs.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.town,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$riskLevel Risk Level',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isHighRisk ? cs.error : cs.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isHighRisk ? cs.error : cs.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(p.probability * 100).toStringAsFixed(0)}%',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProbabilityBar(value: p.probability, threshold: run.threshold),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isHighRisk 
                        ? cs.error.withOpacity(0.05) 
                        : cs.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isHighRisk ? Icons.warning_rounded : Icons.check_circle_rounded,
                        color: isHighRisk ? cs.error : cs.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isHighRisk 
                              ? 'Heatwave risk elevated — take precautions'
                              : 'Normal conditions expected',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isHighRisk ? cs.error : cs.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.hourglass_empty, color: Colors.grey, size: 48),
          const SizedBox(height: 16),
          Text(
            'Predictions not yet display',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_off, color: Colors.grey, size: 48),
          const SizedBox(height: 16),
          Text(
            'No Predictions Available',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Run a new prediction to see heatwave forecasts',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}