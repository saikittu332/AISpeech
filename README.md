# AISpeech - AI-Powered Speech Recognition iOS App

[![Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](https://www.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.5+-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

AISpeech is a complete, production-ready iOS application that provides real-time speech recognition, text-to-speech conversion, and AI-powered text analysis. Built with Swift and SwiftUI, it demonstrates modern iOS development best practices.

## Features

### 🎤 Speech Recognition
- Real-time speech-to-text conversion using Apple's Speech framework
- Support for multiple languages
- High-accuracy transcription with confidence scores
- Audio recording and playback

### 🤖 AI Processing
- Sentiment analysis
- Keyword extraction
- Automatic text summarization
- Real-time streaming to backend AI services

### 🔊 Text-to-Speech
- Natural voice synthesis using AVSpeechSynthesizer
- Adjustable speech rate and volume
- Multiple language support
- Voice selection

### 💾 Data Management
- Local persistence with Core Data
- Transcript history with search
- Export and share capabilities
- Secure data storage with Keychain

### 🎨 Modern UI/UX
- Clean SwiftUI-based interface
- Dark mode and light mode support
- Smooth animations and transitions
- Accessibility features (VoiceOver, Dynamic Type)
- Responsive design for all iOS devices

### 🔐 Security & Privacy
- Secure credential storage with Keychain
- Privacy-focused design
- User consent for microphone and speech recognition
- No data sharing without permission

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+
- Active internet connection for AI features

> **💻 Windows Users:** Don't have macOS? See the [Windows Testing Quick Guide](WINDOWS-TESTING.md) or the detailed [Testing on Windows](TESTING.md#testing-on-windows) section for cloud Mac services, GitHub Actions (FREE), and other alternatives.

## Installation

### Using Xcode (macOS Required)

1. Clone the repository:
```bash
git clone https://github.com/saikittu332/AISpeech.git
cd AISpeech
```

2. Open the project in Xcode:
```bash
open AISpeech.xcodeproj
```

3. Select your target device or simulator (iPhone 14 recommended)

4. Build and run (⌘R)

5. For detailed testing instructions, see [TESTING.md](TESTING.md)

### Using Swift Package Manager

1. In Xcode, go to File > Add Packages
2. Enter the repository URL
3. Select the version and add to your project

## Project Structure

```
AISpeech/
├── Sources/
│   ├── App/                    # App entry point and root views
│   │   ├── AISpeechApp.swift
│   │   └── ContentView.swift
│   ├── Models/                 # Data models and Core Data
│   │   ├── User.swift
│   │   ├── SpeechModels.swift
│   │   ├── AppState.swift
│   │   ├── PersistenceController.swift
│   │   ├── TranscriptEntity.swift
│   │   └── AISpeech.xcdatamodeld/
│   ├── ViewModels/            # MVVM ViewModels
│   │   ├── AuthenticationViewModel.swift
│   │   ├── SpeechViewModel.swift
│   │   └── SettingsViewModel.swift
│   ├── Views/                 # SwiftUI Views
│   │   ├── OnboardingView.swift
│   │   ├── LoginView.swift
│   │   ├── RegistrationView.swift
│   │   ├── MainTabView.swift
│   │   ├── SpeechRecognitionView.swift
│   │   ├── HistoryView.swift
│   │   └── SettingsView.swift
│   ├── Services/              # Business logic and API services
│   │   ├── NetworkService.swift
│   │   ├── AuthenticationService.swift
│   │   ├── SpeechRecognitionService.swift
│   │   ├── TextToSpeechService.swift
│   │   └── AIProcessingService.swift
│   ├── Utilities/             # Helper utilities
│   │   ├── Logger.swift
│   │   ├── KeychainManager.swift
│   │   └── Constants.swift
│   └── Extensions/            # Swift extensions
│       └── Extensions.swift
├── Tests/                     # Unit and UI tests
│   ├── ViewModelTests/
│   ├── ServiceTests/
│   └── UITests/
├── Info.plist                 # App configuration
├── Package.swift              # Swift Package Manager
└── README.md                  # This file
```

## Architecture

AISpeech follows the **MVVM (Model-View-ViewModel)** architecture pattern:

- **Models**: Data structures and Core Data entities
- **Views**: SwiftUI views for UI presentation
- **ViewModels**: Business logic and state management
- **Services**: Network, authentication, and speech services

### Key Design Patterns

- **Dependency Injection**: Services injected where needed
- **Singleton Pattern**: Shared services (Logger, KeychainManager)
- **Observer Pattern**: Combine framework for reactive programming
- **Repository Pattern**: Data persistence layer abstraction

## Configuration

### Environment Variables

Set these in your Xcode scheme or through Configuration files:

- `API_BASE_URL`: Backend API base URL (default: https://api.aispeech.com)

### Info.plist Permissions

The following permissions are required:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>AISpeech needs access to your microphone to record and transcribe your speech.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>AISpeech uses speech recognition to convert your voice into text.</string>
```

## Usage

### Basic Speech Recognition

```swift
import AISpeech

let speechService = SpeechRecognitionService.shared

// Request authorization
await speechService.requestAuthorization()

// Start recording
try speechService.startRecording { result in
    print("Transcript: \(result.transcript)")
    print("Confidence: \(result.confidence)")
}

// Stop recording
speechService.stopRecording()
```

### Text-to-Speech

```swift
import AISpeech

let ttsService = TextToSpeechService.shared

// Speak text
ttsService.speak("Hello, World!")

// Adjust settings
ttsService.speechRate = 0.5
ttsService.volume = 1.0

// Stop speaking
ttsService.stop()
```

### AI Processing

```swift
import AISpeech

let aiService = AIProcessingService.shared

// Process transcript
let result = try await aiService.processTranscript(text)
print("Sentiment: \(result.sentiment ?? "N/A")")
print("Keywords: \(result.keywords)")
print("Summary: \(result.summary ?? "N/A")")
```

## Testing

### Testing in Simulator

For comprehensive instructions on testing the app in an iOS simulator, see **[TESTING.md](TESTING.md)**.

Quick start:
1. Open project in Xcode: `xed .`
2. Select iOS simulator (iPhone 14 recommended)
3. Press ⌘R to build and run
4. Test features: speech recognition, text-to-speech, history, settings

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme AISpeech -destination 'platform=iOS Simulator,name=iPhone 14'

# Run specific test
xcodebuild test -scheme AISpeech -only-testing:AISpeechTests/AuthenticationViewModelTests
```

### Test Coverage

- ✅ Unit tests for ViewModels
- ✅ Unit tests for Services
- ✅ Unit tests for Extensions
- ✅ UI tests for key user flows

## API Integration

AISpeech integrates with a backend API for AI processing. The API endpoints include:

- `POST /auth/login` - User authentication
- `POST /auth/register` - User registration
- `POST /ai/process` - Process transcript with AI
- `POST /ai/sentiment` - Analyze sentiment
- `POST /ai/keywords` - Extract keywords
- `POST /ai/summary` - Generate summary

See the [API Documentation](docs/API.md) for details.

## Deployment

### App Store Preparation

1. Update version and build numbers in `Info.plist`
2. Configure signing in Xcode
3. Archive the app (Product > Archive)
4. Upload to App Store Connect
5. Submit for review

### Required Assets

- App Icon (all sizes)
- Launch Screen
- Screenshots for all device sizes
- App preview video (optional)
- Privacy Policy URL
- Terms of Service URL

## Accessibility

AISpeech is designed with accessibility in mind:

- ✅ VoiceOver support for all UI elements
- ✅ Dynamic Type for adjustable text sizes
- ✅ High contrast mode support
- ✅ Voice Control compatibility
- ✅ Keyboard navigation where applicable

## Performance Optimization

- Efficient memory management with ARC
- Background audio processing
- Lazy loading of history items
- Image and data caching
- Core Data batch operations

## Security Best Practices

- ✅ Keychain storage for sensitive data
- ✅ HTTPS-only network communication
- ✅ Certificate pinning (optional)
- ✅ Data encryption at rest
- ✅ Secure coding practices

## Troubleshooting

### Common Issues

**Speech recognition not working:**
- Check microphone permissions in Settings
- Verify speech recognition authorization
- Ensure internet connection (for some features)

**Build errors:**
- Clean build folder (⌘⇧K)
- Delete DerivedData
- Update Xcode to latest version

**Core Data errors:**
- Reset simulator (Device > Erase All Content and Settings)
- Check data model versions

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Apple's Speech and AVFoundation frameworks
- SwiftUI community
- Contributors and testers

## Contact

For questions, issues, or feature requests:

- Email: support@aispeech.com
- GitHub Issues: [https://github.com/saikittu332/AISpeech/issues](https://github.com/saikittu332/AISpeech/issues)
- Twitter: [@AISpeechApp](https://twitter.com/AISpeechApp)

## Roadmap

- [ ] iPad-specific UI optimizations
- [ ] watchOS companion app
- [ ] Offline speech recognition
- [ ] Multiple AI provider support
- [ ] Voice commands
- [ ] Cloud sync
- [ ] Widgets
- [ ] Shortcuts support

---

Made with ❤️ by the AISpeech Team
