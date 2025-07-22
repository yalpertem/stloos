# iOS Deployment GitHub Secrets Configuration

## Required GitHub Secrets

### 1. IOS_P12_BASE64
Your iOS distribution certificate in base64 format.

```bash
# Convert your .p12 certificate to base64
base64 -i YourDistributionCertificate.p12 | pbcopy
```

### 2. IOS_P12_PASSWORD
The password for your .p12 certificate file.

### 3. BUILD_PROVISION_PROFILE_BASE64
Your App Store provisioning profile in base64 format.

```bash
# Download from Apple Developer Portal and convert to base64
base64 -i YourAppStore.mobileprovision | pbcopy
```

### 4. KEYCHAIN_PASSWORD
A password for the temporary keychain (can be any secure password).
Example: `temp-keychain-password-123`

### 5. APP_STORE_CONNECT_PRIVATE_KEY
Your App Store Connect API private key (.p8 file) in base64 format.

```bash
# Convert your .p8 file to base64
base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
```

### 6. APP_STORE_CONNECT_API_KEY
Your App Store Connect API Key ID (e.g., `U7X6N6ANS7`).

### 7. APP_STORE_CONNECT_API_ISSUER
Your App Store Connect Issuer ID (e.g., `69a6de7e-xxxx-xxxx-xxxx-5e8376db2138`).

## Migration from Old Workflow

If you're migrating from the old workflow, here's the mapping:

- `IOS_DISTRIBUTION_CERT_BASE64` → `IOS_P12_BASE64`
- `IOS_DISTRIBUTION_CERT_PASSWORD` → `IOS_P12_PASSWORD`
- `APPSTORE_KEY_ID` → `APP_STORE_CONNECT_API_KEY`
- `APPSTORE_ISSUER_ID` → `APP_STORE_CONNECT_API_ISSUER`
- `APPSTORE_PRIVATE_KEY` → `APP_STORE_CONNECT_PRIVATE_KEY` (must be base64 encoded)

New secrets to add:
- `BUILD_PROVISION_PROFILE_BASE64`
- `KEYCHAIN_PASSWORD`