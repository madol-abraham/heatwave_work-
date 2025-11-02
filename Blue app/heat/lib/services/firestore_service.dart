import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Submit a support issue to Firestore
  static Future<String> submitSupportIssue({
    required String name,
    required String email,
    required String issueType,
    required String message,
  }) async {
    try {
      final docData = {
        'name': name.trim(),
        'email': email.trim(),
        'issueType': issueType,
        'message': message.trim(),
        'status': 'open',
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid ?? 'anonymous',
      };
      
      final docRef = await _firestore
          .collection('support')
          .add(docData);
      
      return docRef.id;
      
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  /// Submit feedback to Firestore
  static Future<String> submitFeedback({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      final docData = {
        'name': name.trim(),
        'email': email.trim(),
        'message': message.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid ?? 'anonymous',
      };
      
      final docRef = await _firestore
          .collection('feedback')
          .add(docData);
      
      return docRef.id;
      
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }

  /// Test Firestore connection
  static Future<bool> testConnection() async {
    try {
      print('Testing Firestore connection...');
      
      // Try to read from a collection (this will test permissions)
      await _firestore
          .collection('test')
          .limit(1)
          .get(const GetOptions(source: Source.server));
      
      print('Firestore connection test successful');
      return true;
      
    } catch (e) {
      print('Firestore connection test failed: $e');
      return false;
    }
  }

  /// Handle Firebase-specific errors
  static Exception _handleFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return Exception('Permission denied. Please check your account permissions.');
      case 'unavailable':
        return Exception('Service temporarily unavailable. Please try again later.');
      case 'deadline-exceeded':
        return Exception('Request timeout. Please check your internet connection.');
      case 'resource-exhausted':
        return Exception('Service quota exceeded. Please try again later.');
      case 'unauthenticated':
        return Exception('Authentication required. Please sign in again.');
      case 'not-found':
        return Exception('Database collection not found.');
      case 'already-exists':
        return Exception('Document already exists.');
      case 'failed-precondition':
        return Exception('Operation failed due to system state.');
      case 'aborted':
        return Exception('Operation was aborted. Please try again.');
      case 'out-of-range':
        return Exception('Invalid data range provided.');
      case 'unimplemented':
        return Exception('Operation not supported.');
      case 'internal':
        return Exception('Internal server error. Please try again later.');
      case 'data-loss':
        return Exception('Data corruption detected. Please contact support.');
      default:
        return Exception('Database error: ${e.message ?? e.code}');
    }
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Check if user is authenticated
  static bool isUserAuthenticated() {
    return _auth.currentUser != null;
  }
}