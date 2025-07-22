# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application called "shittheyleaveonourstreets" - an image display app that shows paginated images from a Supabase database. The app features pagination controls and minimal metadata display. Currently focused on iOS development.

## Development Commands

### Running the App
```bash
flutter run
```

### Building
```bash
# iOS (primary target platform)
flutter build ios

# Android (not currently in use)
flutter build apk
flutter build appbundle

# Web (not currently in use)
flutter build web
```

### Testing
```bash
flutter test
```

### Code Analysis and Linting
```bash
flutter analyze
```

### Dependency Management
```bash
flutter pub get
flutter pub upgrade
```

### Clean Build
```bash
flutter clean
flutter pub get
```

### Database Management
```bash
# Reset local Supabase database (applies migrations and seeds)
supabase db reset --local

# Stop and start Supabase services
supabase stop
supabase start
```

### Environment Configuration
The app uses environment variables for Supabase configuration to support different environments:

- **Local Development**: Uses `.env.local` file with local Supabase instance
- **Production**: Uses `.env.production` file with production Supabase values

#### Environment Files
- `.env.local` - Local development environment (contains localhost URLs and demo keys)
- `.env.production` - Production environment template (update with your production values)

#### Required Environment Variables
- `SUPABASE_URL` - Your Supabase project URL
- `SUPABASE_ANON_KEY` - Your Supabase anonymous/public key

#### Local Development Setup
For local development with Supabase local instance:
```bash
# .env.local (already configured)
SUPABASE_URL=http://127.0.0.1:54321
SUPABASE_ANON_KEY=your-local-anon-key
```

#### Production Setup
Update `.env.production` with your production Supabase values:
```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-production-anon-key
```

#### GitHub Actions Deployment
For production deployment via GitHub Actions, add these secrets to your repository:
- `SUPABASE_URL` - Your production Supabase project URL
- `SUPABASE_ANON_KEY` - Your production Supabase anonymous key

### SQL Linting and Formatting
```bash
# Install development dependencies (sqlfluff, pre-commit)
pip install -r requirements-dev.txt

# Install pre-commit hooks
pre-commit install

# Run sqlfluff on SQL files manually
sqlfluff lint supabase/migrations/*.sql --dialect postgres
sqlfluff fix supabase/migrations/*.sql --dialect postgres

# Run pre-commit hooks manually
pre-commit run --all-files
```

## Architecture

### Project Structure
- `lib/main.dart` - Single entry point containing the entire app logic with pagination
- `assets/` - Contains 12 JPEG images (image1.jpeg through image12.jpeg)
- `supabase/migrations/` - Database migration files with sample image data
- `android/` - Android-specific configuration and build files
- `ios/` - iOS-specific configuration and build files (primary target)
- `web/` - Web platform assets and configuration

### App Architecture
The app uses a simple single-file architecture:
- `MyApp` - Root MaterialApp widget with green theme
- `MyHomePage` - Main screen with paginated image list and navigation controls
- Supabase integration for database-driven image loading
- Pagination with 5 images per page
- Minimal metadata display showing created_at dates

### Key Configuration
- Flutter SDK: ^3.0.0
- Uses Material Design with green theme
- Primary target platform: iOS
- Supabase Flutter integration for database connectivity
- Static assets declared in pubspec.yaml
- Flutter lints enabled for code quality
- Page size: 5 images per page

### Build Configuration
- Android: Uses Kotlin, targets API levels defined in build.gradle.kts
- iOS: Swift-based with standard Xcode project structure
- Version: 1.0.0+3

## CI/CD

### GitHub Actions
- **iOS Release Workflow** (`.github/workflows/ios-release.yml`): Automated iOS App Store deployment
  - Triggers on version tags (`v*`) or manual dispatch
  - Runs on self-hosted macOS runner
  - Builds, signs, and uploads to App Store Connect
  - Creates GitHub release with IPA artifact

### Required Secrets for iOS Deployment
Set these in GitHub repository settings:
- `IOS_DISTRIBUTION_CERT_BASE64`: Base64 encoded iOS distribution certificate (.p12)
  ```bash
  base64 -i Certificates.p12 | pbcopy
  ```
- `IOS_DISTRIBUTION_CERT_PASSWORD`: Password for the distribution certificate
- `APPSTORE_ISSUER_ID`: App Store Connect API issuer ID
- `APPSTORE_KEY_ID`: App Store Connect API key ID  
- `APPSTORE_PRIVATE_KEY`: App Store Connect API private key content (NOT base64 encoded)
  - Copy the ENTIRE content of your .p8 file including the header and footer:
    ```
    -----BEGIN PRIVATE KEY-----
    [Your key content here]
    -----END PRIVATE KEY-----
    ```
  - Make sure to preserve line breaks when adding to GitHub secrets

## Development Notes

The app is intentionally minimal with all logic contained in main.dart. When making changes:
- Images are loaded from the assets folder
- The app uses SafeArea for proper screen boundaries
- Green color scheme is defined in the theme
- Turkish comments exist in the codebase (e.g., "Ortalanmış başlık", "Scrollable görseller")