# MediConsult Flutter Application - Pubspec.yaml

This document contains the complete pubspec.yaml configuration for the MediConsult telemedicine application.

```yaml
name: mediconsult_app
description: A new Flutter project for MediConsult telemedicine application.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.4.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Core Framework
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  get_it: ^7.6.4
  injectable: ^2.3.2
  dartz: ^0.10.1
  
  # Navigation
  go_router: ^12.1.1
  
  # Networking
  dio: ^5.4.0
  retrofit: ^4.0.3
  connectivity_plus: ^5.0.2
  
  # Firebase Suite
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  firebase_messaging: ^14.7.10
  
  # Video Calling
  agora_rtc_engine: ^6.2.4
  permission_handler: ^11.1.0
  
  # AI & Speech
  google_generative_ai: ^0.2.0
  speech_to_text: ^6.5.1
  flutter_tts: ^3.8.5
  
  # Local Storage & Security
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.0.0
  encrypt: ^5.0.3
  
  # UI Components
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  lottie: ^3.0.0
  
  # Utilities
  logger: ^2.0.2+1
  intl: ^0.19.0
  uuid: ^4.2.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  
  # Code Generation
  freezed: ^2.4.6
  freezed_annotation: ^2.4.1
  json_serializable: ^6.7.1
  json_annotation: ^4.8.1
  build_runner: ^2.4.8
  injectable_generator: ^2.4.1
  retrofit_generator: ^8.0.4

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

## Key Dependencies

### State Management & Architecture
- `flutter_bloc: ^8.1.3` - BLoC pattern implementation
- `equatable: ^2.0.5` - Simplify equality comparisons
- `get_it: ^7.6.4` - Service locator for dependency injection
- `injectable: ^2.3.2` - Compile-time dependency injection
- `dartz: ^0.10.1` - Functional programming utilities

### Navigation
- `go_router: ^12.1.1` - Declarative routing solution

### Networking
- `dio: ^5.4.0` - Powerful HTTP client
- `retrofit: ^4.0.3` - Type-safe REST client generator
- `connectivity_plus: ^5.0.2` - Network connectivity checker

### Firebase Services
- `firebase_core: ^2.24.2` - Core Firebase functionality
- `firebase_auth: ^4.16.0` - Authentication services
- `cloud_firestore: ^4.14.0` - Cloud database
- `firebase_storage: ^11.6.0` - Cloud storage
- `firebase_messaging: ^14.7.10` - Push notifications

### Video Calling
- `agora_rtc_engine: ^6.2.4` - Real-time communication SDK
- `permission_handler: ^11.1.0` - Handle device permissions

### AI & Speech Processing
- `google_generative_ai: ^0.2.0` - Google's Gemini AI API
- `speech_to_text: ^6.5.1` - Speech recognition
- `flutter_tts: ^3.8.5` - Text-to-speech

### Data Storage & Security
- `hive: ^2.2.3` - Lightweight key-value database
- `hive_flutter: ^1.1.0` - Hive extensions for Flutter
- `flutter_secure_storage: ^9.0.0` - Secure storage for sensitive data
- `encrypt: ^5.0.3` - Encryption utilities

### UI Components
- `flutter_svg: ^2.0.9` - SVG rendering
- `cached_network_image: ^3.3.1` - Cached image loading
- `shimmer: ^3.0.0` - Shimmer loading effects
- `lottie: ^3.0.0` - Animated graphics

### Development Tools
- `freezed: ^2.4.6` - Code generation for immutable classes
- `build_runner: ^2.4.8` - Code generation tool
- `injectable_generator: ^2.4.1` - DI code generator
- `retrofit_generator: ^8.0.4` - Retrofit code generator