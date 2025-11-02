import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static User? get currentUser => _auth.currentUser;
  static bool get isLoggedIn => _auth.currentUser != null;

  static Future<UserCredential> registerUser({
    required String name,
    required String email,
    required String phone,
    required String location,
    required String password,
  }) async {
    // Create user with email and password
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Store user data in Firestore
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'language': 'en', // Default to English
      'createdAt': FieldValue.serverTimestamp(),
      'alertPreferences': {
        'smsEnabled': true,
        'emailEnabled': true,
        'threshold': 0.65,
      },
    });

    return credential;
  }

  static Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No account found with this email address');
        case 'invalid-email':
          throw Exception('Invalid email address');
        case 'too-many-requests':
          throw Exception('Too many requests. Please try again later');
        default:
          throw Exception('Failed to send reset email: ${e.message}');
      }
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    if (!isLoggedIn) return null;
    
    final doc = await _firestore.collection('users').doc(currentUser!.uid).get();
    return doc.data();
  }

  static Future<void> updateUserData(Map<String, dynamic> data) async {
    if (!isLoggedIn) return;
    
    try {
      // update existing document
      await _firestore.collection('users').doc(currentUser!.uid).update(data);
    } catch (e) {
      // If document doesn't exist, create it
      await _firestore.collection('users').doc(currentUser!.uid).set({
        'name': currentUser!.displayName ?? 'User',
        'email': currentUser!.email ?? '',
        'phone': '',
        'location': '',
        'createdAt': FieldValue.serverTimestamp(),
        ...data,
      });
    }
    
    // Update Firebase Auth profile if name is being updated
    if (data.containsKey('name')) {
      await currentUser!.updateDisplayName(data['name']);
    }
  }



  static Future<void> sendPhoneVerification(String phoneNumber) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        // Handle code sent
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
      },
    );
  }

  static Future<void> deleteAccount() async {
    if (!isLoggedIn) throw Exception('No user logged in');
    
    try {
      final user = _auth.currentUser!;
      
      // Delete user data from Firestore
      await _firestore.collection('users').doc(user.uid).delete();
      
      // Delete user alerts
      final alertsQuery = await _firestore
          .collection('alerts')
          .where('userId', isEqualTo: user.uid)
          .get();
      
      for (final doc in alertsQuery.docs) {
        await doc.reference.delete();
      }
      
      // Delete Firebase Auth account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Please sign in again before deleting your account');
      } else {
        throw Exception('Failed to delete account: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}