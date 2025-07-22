# iOS Deployment GitHub Secrets Guide

This guide explains how to generate all the required GitHub secrets for the iOS deployment workflow.

## Required Secrets

### 1. `IOS_P12_BASE64` - iOS Distribution Certificate

The P12 certificate contains your iOS distribution certificate and private key.

**Generation Steps:**
1. Open Keychain Access on macOS
2. Find your iOS Distribution certificate (usually named "iPhone Distribution: Your Name")
3. Right-click and select "Export..."
4. Choose Personal Information Exchange (.p12) format
5. Set a password when prompted (save this for `IOS_P12_PASSWORD`)
6. Convert to base64:
   ```bash
   base64 -i your_certificate.p12 | pbcopy
   ```
7. Paste the copied value as the GitHub secret

### 2. `IOS_P12_PASSWORD` - Certificate Password

This is the password you set when exporting the P12 certificate in step 1.5 above.

### 3. `BUILD_PROVISION_PROFILE_BASE64` - Provisioning Profile

The provisioning profile links your app, certificates, and devices.

**Generation Steps:**
1. Go to [Apple Developer Portal](https://developer.apple.com)
2. Navigate to Certificates, Identifiers & Profiles > Profiles
3. Create or download your App Store distribution profile
4. Convert to base64:
   ```bash
   base64 -i your_profile.mobileprovision | pbcopy
   ```
5. Paste the copied value as the GitHub secret

### 4. `KEYCHAIN_PASSWORD` - Temporary Keychain Password

This is a password for the temporary keychain created during deployment. You can use any secure password.

**Example:**
```bash
# Generate a random password
openssl rand -base64 32
```

### 5. `APP_STORE_CONNECT_PRIVATE_KEY` - App Store Connect API Key

**Generation Steps:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to Users and Access > Keys
3. Click the + button to create a new key
4. Select appropriate permissions (usually "Admin" or "App Manager")
5. Download the .p8 file (you can only download it once!)
6. Convert to base64:
   ```bash
   base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
   ```
7. Paste the copied value as the GitHub secret

### 6. `APP_STORE_CONNECT_API_KEY` - API Key ID

This is the Key ID from the API key you created in step 5.

**Location:** Visible in App Store Connect > Users and Access > Keys

**Format:** 10-character alphanumeric string (e.g., `A1B2C3D4E5`)

### 7. `APP_STORE_CONNECT_API_ISSUER` - Issuer ID

**Location:** App Store Connect > Users and Access > Keys (top of the page)

**Format:** UUID (e.g., `12345678-1234-1234-1234-123456789012`)

### 8. `SUPABASE_STAGING_URL` (Optional)

Your Supabase project URL for staging environment.

**Format:** `https://[project-id].supabase.co`

### 9. `SUPABASE_STAGING_ANON_KEY` (Optional)

Your Supabase anonymous key for staging environment.

## Adding Secrets to GitHub

1. Go to your repository on GitHub
2. Navigate to Settings > Secrets and variables > Actions
3. Click "New repository secret"
4. Add each secret with the exact name listed above
5. Paste the value (ensure no extra whitespace)

## Verification Checklist

Before running the workflow, ensure:

- [ ] All secrets are added to GitHub
- [ ] P12 certificate is valid and not expired
- [ ] Provisioning profile matches your app bundle ID
- [ ] App Store Connect API key has appropriate permissions
- [ ] Your Apple Developer account is in good standing
- [ ] The bundle identifier in your Flutter app matches the provisioning profile

## Troubleshooting

**Certificate Issues:**
- Ensure the certificate hasn't expired
- Verify it's a distribution certificate, not development
- Check that the certificate is properly installed in Keychain

**Provisioning Profile Issues:**
- Ensure it's an App Store distribution profile
- Verify the bundle ID matches your app
- Check expiration date

**API Key Issues:**
- Ensure you're using the correct Key ID (not the filename)
- Verify the key has proper permissions
- Remember the .p8 file can only be downloaded once

**Base64 Encoding Issues:**
- Ensure no line breaks in the base64 output
- Use `pbcopy` to avoid manual copying errors
- Verify the entire content is copied (check length)