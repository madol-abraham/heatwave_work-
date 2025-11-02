# Get SHA-1 Fingerprint for Google Sign-In

## Quick Command

Open terminal/command prompt in your project root and run:

```bash
cd android
./gradlew signingReport
```

## What to Look For

Look for output like this:
```
Variant: debug
Config: debug
Store: C:\Users\YourName\.android\debug.keystore
Alias: AndroidDebugKey
MD5: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX  <-- Copy this
SHA-256: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

## Copy the SHA1 Value

Copy the SHA1 fingerprint (the long string with colons) and add it to:

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: **harara-253af**
3. Go to **Project Settings** (gear icon)
4. Scroll down to **Your apps** section
5. Click on your Android app
6. Scroll to **SHA certificate fingerprints**
7. Click **Add fingerprint**
8. Paste your SHA1 fingerprint
9. Click **Save**

## Alternative Method (if gradlew doesn't work)

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

## For Windows Users

If using Windows Command Prompt:
```cmd
cd android
gradlew signingReport
```

## After Adding SHA-1

1. Wait 5-10 minutes for changes to propagate
2. Restart your app
3. Try Google Sign-In again

## Verify Google Sign-In is Enabled

1. Firebase Console → Authentication → Sign-in method
2. Make sure **Google** is **Enabled**
3. Make sure your app's package name is listed: `com.harara.app`