import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInTest {
  static Future<void> testConfiguration() async {
    if (kDebugMode) {
      print('=== Testing Google Sign-In Configuration ===');
      
      try {
        // Test 1: Check if GoogleSignIn can be initialized
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );
        print('✓ GoogleSignIn initialized successfully');
        
        // Test 2: Check current sign-in status
        final isSignedIn = await googleSignIn.isSignedIn();
        print('Current sign-in status: $isSignedIn');
        
        // Test 3: Try silent sign-in (won't show UI)
        final GoogleSignInAccount? account = await googleSignIn.signInSilently();
        if (account != null) {
          print('✓ Silent sign-in successful: ${account.email}');
        } else {
          print('ℹ No cached Google account found');
        }
        
        // Test 4: Check Firebase Auth status
        final User? firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          print('✓ Firebase user: ${firebaseUser.email}');
        } else {
          print('ℹ No Firebase user signed in');
        }
        
        print('=== Configuration Test Complete ===');
        
      } catch (e) {
        print('❌ Configuration test failed: $e');
        
        // Provide specific troubleshooting advice
        if (e.toString().contains('PlatformException')) {
          print('💡 Troubleshooting:');
          print('   1. Check if google-services.json is in android/app/');
          print('   2. Verify SHA-1 fingerprint is added to Firebase Console');
          print('   3. Ensure Google Sign-In is enabled in Firebase Auth');
          print('   4. Check if Google Play Services is installed/updated');
        }
      }
    }
  }
  
  static Future<void> getDebugInfo() async {
    if (kDebugMode) {
      print('=== Google Sign-In Debug Information ===');
      
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );
        
        // Get current account without triggering sign-in
        final GoogleSignInAccount? currentAccount = googleSignIn.currentUser;
        print('Current Google account: ${currentAccount?.email ?? 'None'}');
        
        // Check if we can access Google Sign-In at all
        final bool canAccessGoogleSignIn = await googleSignIn.isSignedIn();
        print('Can access Google Sign-In: $canAccessGoogleSignIn');
        
        print('=== End Debug Information ===');
        
      } catch (e) {
        print('❌ Debug info failed: $e');
      }
    }
  }
}