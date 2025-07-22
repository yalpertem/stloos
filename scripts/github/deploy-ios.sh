#!/usr/bin/env bash

# Requires:
#BUILD_CERTIFICATE_BASE64
#P12_PASSWORD
#BUILD_PROVISION_PROFILE_BASE64
#KEYCHAIN_PASSWORD
#STORE_PRIVATE_KEY
#APP_STORE_CONNECT_API_KEY

# Check required environment variables
required_vars=("BUILD_CERTIFICATE_BASE64" "P12_PASSWORD" "BUILD_PROVISION_PROFILE_BASE64" "KEYCHAIN_PASSWORD" "STORE_PRIVATE_KEY" "APP_STORE_CONNECT_API_KEY" "APP_STORE_CONNECT_ISSUER_ID")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: Required environment variable $var is not set"
        echo "This script requires the following environment variables:"
        printf '%s\n' "${required_vars[@]}"
        exit 1
    fi
done

# Install the provisioning profile
# create variables
CERTIFICATE_PATH=build_certificate.p12
PP_PATH=build_pp.mobileprovision
KEYCHAIN_PATH=app-signing.keychain-db

# import certificate and provisioning profile from secrets
echo -n "$BUILD_CERTIFICATE_BASE64" | base64 --decode -o $CERTIFICATE_PATH
echo -n "$BUILD_PROVISION_PROFILE_BASE64" | base64 --decode -o $PP_PATH

# create temporary keychain
security create-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH || true
security set-keychain-settings -lut 21600 $KEYCHAIN_PATH
security unlock-keychain -p "$KEYCHAIN_PASSWORD" $KEYCHAIN_PATH

# import certificate to keychain
security import $CERTIFICATE_PATH -P "$P12_PASSWORD" -A -t cert -f pkcs12 -k $KEYCHAIN_PATH
security list-keychain -d user -s $KEYCHAIN_PATH
security default-keychain -d user -s "$KEYCHAIN_PATH"
security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH"

# Verify certificate import
echo "Checking imported certificates:"
security find-identity -v -p codesigning $KEYCHAIN_PATH

# Check system-wide certificates too
echo "Checking system certificates:"
security find-identity -v -p codesigning

# apply provisioning profile
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp $PP_PATH ~/Library/MobileDevice/Provisioning\ Profiles

# Verify provisioning profile
echo "Checking provisioning profile:"
ls -la ~/Library/MobileDevice/Provisioning\ Profiles/
echo "Provisioning profile details:"
security cms -D -i $PP_PATH

# create store connect private key
mkdir private_keys
echo -n "$STORE_PRIVATE_KEY" | base64 --decode -o private_keys/AuthKey_$APP_STORE_CONNECT_API_KEY.p8

# Get Flutter dependencies
flutter pub get

# Check Xcode project signing settings
echo "Checking Xcode project configuration:"
cat ios/Runner.xcodeproj/project.pbxproj | grep -A 5 -B 5 "CODE_SIGN"

echo "Current keychain list:"
security list-keychains -d user

# Build IOS Release with xcodebuild arguments to override code signing
echo "Building IPA with xcodebuild code signing override..."
flutter build ipa --export-options-plist=ios/ExportOptions.plist --verbose \
  --build-name=1.0.0 \
  --build-number=3 \
  --xcodebuild-arg="CODE_SIGN_IDENTITY=Apple Distribution" \
  --xcodebuild-arg="PROVISIONING_PROFILE_SPECIFIER=a7326452-a57c-4482-b96c-7e0f81dc8ee9"

# Check if IPA was created
if [ ! -f build/ios/ipa/*.ipa ]; then
    echo "Error: IPA file not found. Build may have failed."
    echo "Checking build directory structure:"
    ls -la build/ios/
    exit 1
fi

# Publish to Apple Store Connect
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey $APP_STORE_CONNECT_API_KEY --apiIssuer $APP_STORE_CONNECT_ISSUER_ID

# Clean up keychain and provisioning profile
#security delete-keychain $RUNNER_TEMP/app-signing.keychain-db
#rm ~/Library/MobileDevice/Provisioning\ Profiles/build_pp.mobileprovision
#rm -rf private_keys