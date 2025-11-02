# Admin Dashboard Setup Guide

## 1. Grant Admin Access

To make a user an admin, add the `isAdmin` field to their user document in Firebase Console:

### Firebase Console Steps:
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: **harara-253af**
3. Go to **Firestore Database**
4. Navigate to **users** collection
5. Find the user document you want to make admin
6. Click **Edit** and add this field:
   ```json
   {
     "isAdmin": true
   }
   ```
7. Click **Save**

## 2. Admin Dashboard Features

### Manual Alert Creation:
- **Message**: Up to 160 characters (SMS compatible)
- **Severity**: Low, Moderate, High, Critical
- **Target Audience**: All Users or Specific Town
- **Delivery Methods**: 
  - 📱 Push Notification (in-app)
  - 📨 SMS (via Africa's Talking)

### Alert Targeting:
- **All Users**: Sends to every registered user
- **Specific Town**: Sends only to users in selected town (Juba, Wau, Yambio, Bor, Malakal, Bentiu)

## 3. How It Works

### Admin Creates Alert:
1. Admin opens drawer menu → "Admin Dashboard"
2. Fills alert form with message and settings
3. Selects delivery methods (SMS, Push, or Both)
4. Clicks "Send Alert"

### Alert Delivery Process:
```
Admin Dashboard → FastAPI Endpoint → Africa's Talking SMS + Firebase → Users
```

### Users Receive Alerts:
- **SMS**: Direct text message to phone number
- **Push Notification**: In-app notification
- **Alerts History**: Alert appears in app's alerts screen

## 4. FastAPI Integration

The admin dashboard calls your FastAPI endpoint:
- **URL**: `https://harara-heat-dror.onrender.com/alerts/manual`
- **Method**: POST
- **Payload**:
  ```json
  {
    "message": "Alert message text",
    "severity": "high",
    "target_type": "town",
    "target_value": "Juba",
    "send_sms": true,
    "send_push": true
  }
  ```

## 5. Admin Access Control

- Only users with `isAdmin: true` see "Admin Dashboard" in drawer menu
- Admin status is checked on every admin action
- Non-admin users cannot access admin features

## 6. Testing Admin Features

1. **Make yourself admin** in Firebase Console
2. **Restart the app** to refresh admin status
3. **Open drawer menu** - you should see "Admin Dashboard"
4. **Create test alert** with both SMS and push enabled
5. **Check delivery** - users should receive both SMS and in-app notification

## 7. SMS Costs (Africa's Talking)

- **Approximate cost**: $0.02-0.05 per SMS
- **1000 users**: $20-50 per alert
- **Recommendation**: Use SMS for high/critical alerts only

## 8. Security Notes

- Admin access is role-based (Firebase Firestore)
- All admin actions are logged
- FastAPI endpoint should validate admin permissions
- Consider adding admin action audit trail

## 9. Future Enhancements

- **Scheduled Alerts**: Send alerts at specific times
- **Alert Templates**: Pre-defined alert messages
- **Delivery Reports**: Track SMS delivery status
- **User Preferences**: Let users opt-out of SMS
- **Alert Analytics**: View alert engagement metrics