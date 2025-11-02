# Google Sign-In Troubleshooting Guide

## Common Issues and Solutions

### 1. SHA-1 Fingerprint Missing
**Problem**: Google Sign-In fails with "sign_in_failed" error
**Solution**: 
1. Get your SHA-1 fingerprint:
   ```bash
   cd android
   ./gradlew signingReport
   ```
2. Copy the SHA-1 fingerprint from the debug variant
3. Add it to Firebase Console → Project Settings → Your Apps → Android App → SHA certificate fingerprints

### 2. Google Sign-In Not Enabled
**Problem**: "operation-not-allowed" error
**Solution**:
1. Go to Firebase Console → Authentication → Sign-in method
2. Enable Google sign-in provider
3. Add your app's package name and SHA-1 fingerprint

### 3. Package Name Mismatch
**Problem**: Authentication fails silently or with credential errors
**Solution**:
1. Check `android/app/build.gradle` applicationId matches Firebase project
2. Verify `google-services.json` has the correct package name
3. Re-download `google-services.json` if needed

### 4. Google Play Services Issues
**Problem**: "Google Play Services not available" error
**Solution**:
1. Update Google Play Services on device/emulator
2. Use a device with Google Play Services (not emulator without Google APIs)
3. Test on physical device if emulator issues persist

### 5. Network/Connectivity Issues
**Problem**: Network-related sign-in failures
**Solution**:
1. Check internet connection
2. Try on different network
3. Disable VPN if active
4. Check firewall settings

## Debug Steps

1. **Check Configuration**:
   - Tap "Test Google Sign-In Config (Debug)" button on login screen
   - Check console logs for detailed error messages

2. **Verify Files**:
   - Ensure `google-services.json` exists in `android/app/`
   - Verify `firebase_options.dart` has correct configuration

3. **Test Environment**:
   - Test on physical device with Google Play Services
   - Try different Google accounts
   - Test with fresh app install

## Manual Verification Checklist

- [ ] SHA-1 fingerprint added to Firebase Console
- [ ] Google Sign-In enabled in Firebase Authentication
- [ ] Package name matches in all configurations
- [ ] google-services.json is in correct location
- [ ] Google Play Services updated on test device
- [ ] Internet connection working
- [ ] Firebase project has billing enabled (if required)

## Getting SHA-1 Fingerprint

### For Debug Build:
```bash
cd android
./gradlew signingReport
```

### Alternative Method:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

## Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project (harara-253af)
3. Go to Authentication → Sign-in method
4. Enable Google provider
5. Add SHA-1 fingerprint in Project Settings → Your Apps → Android App

## Testing

Use the debug button in the login screen to test configuration and check console logs for detailed error information.