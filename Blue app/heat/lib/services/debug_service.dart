import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DebugService {
  static void logGoogleSignInStatus() async {
    if (kDebugMode) {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final isSignedIn = await googleSignIn.isSignedIn();
        final currentUser = await googleSignIn.signInSilently();
        
        print('=== Google Sign-In Debug Info ===');
        print('Is signed in: $isSignedIn');
        print('Current user: ${currentUser?.email ?? 'None'}');
        print('Firebase user: ${FirebaseAuth.instance.currentUser?.email ?? 'None'}');
        print('================================');
      } catch (e) {
        print('Debug error: $e');
      }
    }
  }
  
  static void logFirebaseConfig() {
    if (kDebugMode) {
      print('=== Firebase Debug Info ===');
      print('Firebase app: ${FirebaseAuth.instance.app.name}');
      print('Current user: ${FirebaseAuth.instance.currentUser?.email ?? 'None'}');
      print('===========================');
    }
  }
}