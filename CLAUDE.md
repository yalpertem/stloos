# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application called "shittheyleaveonourstreets" - a simple image display app that shows three static images in a scrollable interface. The app was created with FlutLab and follows standard Flutter project structure.

## Development Commands

### Running the App
```bash
flutter run
```

### Building
```bash
# Android
flutter build apk
flutter build appbundle

# iOS
flutter build ios

# Web
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

## Architecture

### Project Structure
- `lib/main.dart` - Single entry point containing the entire app logic
- `assets/` - Contains three JPEG images (image1.jpeg, image2.jpeg, image3.jpeg)
- `android/` - Android-specific configuration and build files
- `ios/` - iOS-specific configuration and build files
- `web/` - Web platform assets and configuration

### App Architecture
The app uses a simple single-file architecture:
- `MyApp` - Root MaterialApp widget with green theme
- `MyHomePage` - Main screen displaying title and scrollable image list
- No state management, routing, or external dependencies beyond Flutter SDK

### Key Configuration
- Flutter SDK: ^3.0.0
- Uses Material Design
- Target platforms: Android, iOS, Web
- Static assets declared in pubspec.yaml
- Flutter lints enabled for code quality

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
- `IOS_DISTRIBUTION_CERT_PASSWORD`: Password for the distribution certificate
- `APPSTORE_ISSUER_ID`: App Store Connect API issuer ID
- `APPSTORE_KEY_ID`: App Store Connect API key ID  
- `APPSTORE_PRIVATE_KEY`: App Store Connect API private key (.p8 content)

## Development Notes

The app is intentionally minimal with all logic contained in main.dart. When making changes:
- Images are loaded from the assets folder
- The app uses SafeArea for proper screen boundaries
- Green color scheme is defined in the theme
- Turkish comments exist in the codebase (e.g., "Ortalanmış başlık", "Scrollable görseller")