# Google OAuth Setup Guide

This guide will help you configure Google Sign-In authentication for your app.

## Step 1: Create Google OAuth Credentials

1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google+ API or Google Sign-In API
4. Go to "Credentials" in the left sidebar
5. Click "Create Credentials" > "OAuth 2.0 Client IDs"

### For iOS:
- Application type: iOS
- Bundle ID: `com.yalpertem.stloos` (or your app's bundle identifier)
- You'll get a client ID that looks like: `123456789-abcdefghijklmnop.apps.googleusercontent.com`

## Step 2: Configure Environment Files

### Local Development (.env.local):
Replace `your-local-google-client-id` with your actual Google OAuth client ID:
```
GOOGLE_CLIENT_ID=123456789-abcdefghijklmnop.apps.googleusercontent.com
```

### Production (.env.production):
Replace `your-production-google-client-id` with your production Google OAuth client ID:
```
GOOGLE_CLIENT_ID=123456789-abcdefghijklmnop.apps.googleusercontent.com
```

## Step 3: Update iOS Configuration

1. Open `ios/Runner/Info.plist`
2. Replace `YOUR_CLIENT_ID` with your actual client ID (without the `.apps.googleusercontent.com` part):
```xml
<string>com.googleusercontent.apps.123456789-abcdefghijklmnop</string>
```

## Step 4: Configure Supabase Authentication

1. Go to your Supabase dashboard
2. Navigate to Authentication > Providers
3. Enable Google provider
4. Add your Google OAuth client ID and secret
5. Set the redirect URL to: `https://your-project.supabase.co/auth/v1/callback`

## Step 5: Test Authentication

1. Run the app: `flutter run`
2. You should see the login screen
3. Tap "Sign in with Google"
4. Complete the Google authentication flow
5. You should be redirected to the main app with image feed
6. Access your profile by tapping the profile icon in the app bar

## Troubleshooting

### "Sign in failed" Error
- Check that your Google client ID is correctly configured
- Verify that the bundle ID matches in Google Console and Info.plist
- Ensure Supabase Google provider is enabled and configured

### "No Access Token found" Error
- This usually indicates a configuration issue with Google OAuth
- Double-check your client ID and bundle ID configuration

### Build Issues
- Run `flutter clean && flutter pub get` to reset dependencies
- Check that all configuration files are updated correctly

## Security Notes

- Never commit actual client IDs to version control
- Use different OAuth clients for development and production
- Keep your Google OAuth client secret secure in Supabase dashboard

## Development Commands

After configuration, you can use these commands:

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for iOS
flutter build ios

# Run tests
flutter test

# Analyze code
flutter analyze
```