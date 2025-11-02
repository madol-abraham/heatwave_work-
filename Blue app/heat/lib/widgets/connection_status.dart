import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/theme/colors.dart';

class ConnectionStatus extends StatefulWidget {
  const ConnectionStatus({super.key});

  @override
  State<ConnectionStatus> createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  Map<String, dynamic>? _status;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final isOnline = await ApiService.checkApiHealth();
    if (mounted) {
      setState(() => _status = {
        'status': isOnline ? 'online' : 'offline',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status == null) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    final isOnline = _status!['status'] == 'online';
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}