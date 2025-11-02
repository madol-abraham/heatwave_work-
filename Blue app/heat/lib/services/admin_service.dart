import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  static const String _baseUrl = 'https://harara-heat-dror.onrender.com';
  
  static Future<bool> isAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    
    try {
      // Check current user's document
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      final data = doc.data();
      if (data != null) {
        final isAdmin = data['isAdmin'] == true || data['role'] == 'admin';
        if (isAdmin) return true;
      }
      
      // Also check the specific admin document ID
      final adminDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('On35R1CroQll6G8TqTHs')
          .get();
      
      final adminData = adminDoc.data();
      if (adminData != null && user.email != null) {
        // Check if current user's email matches admin document
        // (This is a temporary workaround)
        return adminData['role'] == 'admin';
      }
      
      return false;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }
  
  static Future<void> sendManualAlert({
    required String message,
    required String severity,
    required String targetType,
    String? targetValue,
    required bool sendSMS,
    required bool sendPush,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not authenticated');
    
    // Ensure user has admin privileges in Firestore
    await _ensureAdminPrivileges(user.uid);

    try {
      // 1. Send via FastAPI for SMS
      final response = await http.post(
        Uri.parse('$_baseUrl/alerts/manual'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'severity': severity,
          'town': targetType == 'all' ? 'All Towns' : targetValue ?? 'All Towns',
          'send_sms': sendSMS,
          'send_push': sendPush,
        }),
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to send SMS alert: ${response.body}');
      }

      // 2. Store manual alert in Firestore (only if push notifications enabled)
      if (sendPush) {
        final manualAlertRef = await FirebaseFirestore.instance
            .collection('manual_alerts')
            .add({
          'message': message,
          'severity': severity,
          'targetType': targetType,
          'targetValue': targetValue,
          'createdBy': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
          'sendSMS': sendSMS,
          'sendPush': sendPush,
          'isActive': true,
        });

        // 3. Create individual alert records for users
        await _createUserAlerts(
          manualAlertRef.id,
          message,
          severity,
          targetType,
          targetValue,
        );
      }
    } catch (e) {
      throw Exception('Failed to send manual alert: $e');
    }
  }

  static Future<void> _createUserAlerts(
    String manualAlertId,
    String message,
    String severity,
    String targetType,
    String? targetValue,
  ) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;
      
      // Create alert for current admin user
      await FirebaseFirestore.instance.collection('alerts').add({
        'userId': currentUser.uid,
        'manualAlertId': manualAlertId,
        'town': targetValue ?? 'All Towns',
        'message': message,
        'severity': severity,
        'probability': _getProbabilityFromSeverity(severity),
        'alert': true,
        'read': false,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'manual',
      });
      
    } catch (e) {
      print('Error creating user alerts: $e');
      rethrow;
    }
  }

  static double _getProbabilityFromSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical': return 0.95;
      case 'high': return 0.8;
      case 'moderate': return 0.6;
      case 'low': return 0.4;
      default: return 0.6;
    }
  }
  
  static Future<void> _ensureAdminPrivileges(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      
      if (!userDoc.exists) {
        // Create user document with admin privileges
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({
          'isAdmin': true,
          'role': 'admin',
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        final data = userDoc.data();
        final isAdmin = data?['isAdmin'] == true || data?['role'] == 'admin';
        
        if (!isAdmin) {
          // Update user to have admin privileges
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({
            'isAdmin': true,
            'role': 'admin',
          });
        }
      }
    } catch (e) {
      print('Error ensuring admin privileges: $e');
      throw Exception('Failed to verify admin privileges');
    }
  }
}