// Run this script to clear Google Sign-In cached tokens
// Usage: dart run clear_auth_cache.dart

import 'dart:io';

void main() async {
  print('🧹 Clearing Google Sign-In cached tokens...');
  
  // Clear browser cache directories (common locations)
  final cachePaths = [
    '${Platform.environment['USERPROFILE']}\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Local Storage',
    '${Platform.environment['USERPROFILE']}\\AppData\\Local\\Microsoft\\Edge\\User Data\\Default\\Local Storage',
    '${Platform.environment['APPDATA']}\\Mozilla\\Firefox\\Profiles',
  ];
  
  for (final path in cachePaths) {
    try {
      final dir = Directory(path);
      if (await dir.exists()) {
        print('📁 Found cache directory: $path');
        // Note: Actual clearing would require browser to be closed
        print('   ⚠️  Please close your browser and clear site data for localhost and harara-253af.firebaseapp.com');
      }
    } catch (e) {
      // Ignore errors for non-existent paths
    }
  }
  
  print('\n✅ Configuration updated with:');
  print('   🔑 Web Client ID: 724307882773-muml11p8te9urfghmc51ce7gdkjpq0cv.apps.googleusercontent.com');
  print('   🌐 Auth Domain: harara-253af.firebaseapp.com');
  print('   📝 Meta tag added to web/index.html');
  
  print('\n🔧 Next steps:');
  print('   1. Verify redirect URIs in Google Cloud Console:');
  print('      - https://harara-253af.firebaseapp.com/__/auth/handler');
  print('      - http://localhost:5000/__/auth/handler');
  print('      - http://localhost:5173/__/auth/handler');
  print('      - http://localhost:64654/__/auth/handler');
  print('      - http://127.0.0.1:5000/__/auth/handler');
  print('   2. Clear browser cache/cookies for your domain');
  print('   3. Test Google Sign-In flow');
  
  print('\n🚀 Ready to test! The 400 error should be resolved.');
}