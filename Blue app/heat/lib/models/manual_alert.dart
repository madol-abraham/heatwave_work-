import 'package:cloud_firestore/cloud_firestore.dart';

class ManualAlert {
  final String id;
  final String message;
  final String severity;
  final String targetType;
  final String? targetValue;
  final String createdBy;
  final DateTime createdAt;
  final bool sendSMS;
  final bool sendPush;
  final bool isActive;
  final List<String> sentToUsers;

  ManualAlert({
    required this.id,
    required this.message,
    required this.severity,
    required this.targetType,
    this.targetValue,
    required this.createdBy,
    required this.createdAt,
    required this.sendSMS,
    required this.sendPush,
    this.isActive = true,
    this.sentToUsers = const [],
  });

  factory ManualAlert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ManualAlert(
      id: doc.id,
      message: data['message'] ?? '',
      severity: data['severity'] ?? 'moderate',
      targetType: data['targetType'] ?? 'all',
      targetValue: data['targetValue'],
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      sendSMS: data['sendSMS'] ?? false,
      sendPush: data['sendPush'] ?? false,
      isActive: data['isActive'] ?? true,
      sentToUsers: List<String>.from(data['sentToUsers'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'severity': severity,
      'targetType': targetType,
      'targetValue': targetValue,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'sendSMS': sendSMS,
      'sendPush': sendPush,
      'isActive': isActive,
      'sentToUsers': sentToUsers,
    };
  }

  double get probabilityFromSeverity {
    switch (severity.toLowerCase()) {
      case 'critical': return 0.95;
      case 'high': return 0.8;
      case 'moderate': return 0.6;
      case 'low': return 0.4;
      default: return 0.6;
    }
  }
}