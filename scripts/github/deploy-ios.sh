#!/usr/bin/env bash

# Requires:
#BUILD_CERTIFICATE_BASE64
#P12_PASSWORD
#BUILD_PROVISION_PROFILE_BASE64
#KEYCHAIN_PASSWORD
#STORE_PRIVATE_KEY
#APP_STORE_CONNECT_API_KEY

# Install the provisioning profile
# create variables
CERTIFICATE_PATH=build_certificate.p12
PP_PATH=build_pp.mobileprovision
KEYCHAIN_PATH=app-signing.keychain-db

# import certificate and provisioning profile from secrets
echo -n "$BUILD_CERTIFICATE_BASE64" | base64 --decode -o $CERTIFICATE_PATH
echo -n "$BUILD_PROVISION_PROFILE_BASE64" | base64 --decode -o $PP_PATH

# create temporary keychain
security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH
security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

# import certificate to keychain
security import $CERTIFICATE_PATH -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
security list-keychain -d user -s $KEYCHAIN_PATH
security default-keychain -d user -s "$KEYCHAIN_NAME"
security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"

# apply provisioning profile
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles

# create store connect private key
mkdir private_keys
echo -n "$STORE_PRIVATE_KEY" | base64 --decode -o private_keys/AuthKey_$APP_STORE_CONNECT_API_KEY.p8

# Build IOS Release
flutter build ipa --export-options-plist=ios/ExportOptions.plist

# Publish to Apple Store Connect
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $APP_STORE_CONNECT_API_KEY --apiIssuer $APP_STORE_CONNECT_ISSUER_ID

# Clean up keychain and provisioning profile
security delete-keychain $RUNNER_TEMP/app-signing.keychain-db
rm ~/Library/MobileDevice/Provisioning\ Profiles/build_pp.mobileprovision
rm -rf private_keys