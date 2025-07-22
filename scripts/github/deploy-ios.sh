#!/usr/bin/env bash

set -e  # Exit on error

echo "🚀 Starting iOS deployment process..."

# Requires:
# BUILD_CERTIFICATE_BASE64
# P12_PASSWORD
# BUILD_PROVISION_PROFILE_BASE64
# KEYCHAIN_PASSWORD
# STORE_PRIVATE_KEY
# APP_STORE_CONNECT_API_KEY
# APP_STORE_CONNECT_ISSUER_ID

# Create variables
CERTIFICATE_PATH=$RUNNER_TEMP/build_certificate.p12
PP_PATH=$RUNNER_TEMP/build_pp.mobileprovision
KEYCHAIN_PATH=$RUNNER_TEMP/app-signing.keychain-db
KEYCHAIN_NAME="app-signing"

# Import certificate and provisioning profile from secrets
echo "📦 Importing certificate and provisioning profile..."
echo -n "$BUILD_CERTIFICATE_BASE64" | base64 --decode -o $CERTIFICATE_PATH
echo -n "$BUILD_PROVISION_PROFILE_BASE64" | base64 --decode -o $PP_PATH

# Create temporary keychain
echo "🔐 Creating temporary keychain..."
security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

# Import certificate to keychain
echo "📜 Importing certificate to keychain..."
security import $CERTIFICATE_PATH -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
security list-keychain -d user -s $KEYCHAIN_PATH
security default-keychain -d user -s $KEYCHAIN_NAME
security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

# Apply provisioning profile
echo "📱 Installing provisioning profile..."
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles

# Create store connect private key
echo "🔑 Setting up App Store Connect API key..."
mkdir -p private_keys
echo -n "$STORE_PRIVATE_KEY" | base64 --decode -o private_keys/AuthKey_$APP_STORE_CONNECT_API_KEY.p8

# Build iOS Release
echo "🏗️  Building iOS app..."
flutter build ipa --export-options-plist=ios/ExportOptions.plist

# Publish to Apple Store Connect
echo "📤 Uploading to App Store Connect..."
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $APP_STORE_CONNECT_API_KEY --apiIssuer $APP_STORE_CONNECT_ISSUER_ID

# Clean up keychain and provisioning profile
echo "🧹 Cleaning up..."
security delete-keychain $KEYCHAIN_PATH || true
rm ~/Library/MobileDevice/Provisioning\ Profiles/build_pp.mobileprovision || true
rm -rf private_keys

echo "✅ iOS deployment completed successfully!"