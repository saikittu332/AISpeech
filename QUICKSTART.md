# Quick Start Guide - AISpeech iOS App

This guide will help you get started with the AISpeech iOS application quickly.

## Prerequisites

- Mac with macOS 12.0+
- Xcode 13.0+
- iOS 14.0+ Simulator or Device
- Basic knowledge of Swift and SwiftUI

## Quick Setup (5 minutes)

### 1. Clone and Open

```bash
git clone https://github.com/saikittu332/AISpeech.git
cd AISpeech
xed .
```

### 2. Configure Backend (Optional)

If you have a backend API, set the base URL:

```swift
// In Sources/Services/NetworkService.swift
private let baseURL = "https://your-api-url.com"
```

Or set environment variable in Xcode scheme:
- Edit Scheme → Run → Arguments → Environment Variables
- Add: `API_BASE_URL` = `https://your-api-url.com`

### 3. Build and Run

- Select target: iPhone 14 simulator
- Press ⌘R to build and run

## First Run Experience

### 1. Onboarding
- Swipe through 4 onboarding screens
- Or tap "Skip" to go directly to login

### 2. Registration
- Tap "Sign Up" on login screen
- Enter email, username, password
- Create account

### 3. Main Features
- **Record Tab:** Tap the microphone to start recording
- **History Tab:** View past transcriptions
- **Settings Tab:** Customize app preferences

## Testing Without Backend

The app can be tested without a backend server:

### Mock Mode
1. Comment out network calls in ViewModels
2. Use mock data for testing UI/UX
3. All local features work (speech recognition, TTS, persistence)

### Local Features That Work Offline
- ✅ Speech recognition (uses Apple's framework)
- ✅ Text-to-speech
- ✅ Settings and preferences
- ✅ History storage (Core Data)
- ❌ AI processing (requires backend)
- ❌ Authentication (requires backend)

## Key Directories

```
Sources/
├── App/           - Entry point, main views
├── Models/        - Data models, Core Data
├── ViewModels/    - Business logic
├── Views/         - UI components
├── Services/      - API, speech, auth services
├── Utilities/     - Helpers, logging, constants
└── Extensions/    - Swift extensions
```

## Common Development Tasks

### Add a New View

```swift
// 1. Create file in Sources/Views/
import SwiftUI

struct MyNewView: View {
    var body: some View {
        Text("Hello")
    }
}

// 2. Add to navigation in MainTabView.swift
```

### Add a New Service

```swift
// 1. Create file in Sources/Services/
class MyService {
    static let shared = MyService()
    private init() {}
    
    func doSomething() {
        // Implementation
    }
}

// 2. Use in ViewModel
private let myService = MyService.shared
```

### Add Core Data Entity

1. Open `AISpeech.xcdatamodeld`
2. Add entity with attributes
3. Create NSManagedObject subclass
4. Update PersistenceController if needed

### Add Unit Test

```swift
// In Tests/ViewModelTests/
import XCTest
@testable import AISpeech

final class MyViewModelTests: XCTestCase {
    func testSomething() {
        XCTAssertTrue(true)
    }
}
```

## Debugging Tips

### Speech Recognition Issues
- Check microphone permissions in Settings
- Verify SpeechRecognizer authorization
- Check device audio settings

### Build Errors
- Clean build folder (⌘⇧K)
- Delete DerivedData: `~/Library/Developer/Xcode/DerivedData`
- Restart Xcode

### Runtime Crashes
- Check Console for detailed logs
- Use breakpoints
- Enable Exception Breakpoint

## Useful Xcode Shortcuts

- **⌘R** - Build and Run
- **⌘B** - Build
- **⌘U** - Run Tests
- **⌘K** - Clear Console
- **⌘⇧K** - Clean Build Folder
- **⌘/** - Comment/Uncomment
- **⌘⇧O** - Quick Open

## Configuration Options

### Constants (Sources/Utilities/Constants.swift)

```swift
// Modify these for customization
enum Constants {
    enum UI {
        static let cornerRadius: CGFloat = 12
        static let buttonHeight: CGFloat = 50
    }
    
    enum Speech {
        static let defaultLanguage = "en-US"
        static let minConfidence: Float = 0.5
    }
}
```

### User Defaults Keys
- `hasCompletedOnboarding` - Onboarding status
- `isDarkMode` - Dark mode preference
- `fontSize` - Font size setting
- `selectedLanguage` - Speech language

### Keychain Keys
- `authToken` - Authentication token
- `refreshToken` - Token refresh key

## API Endpoints

Expected backend endpoints:

```
POST /auth/login
POST /auth/register
POST /auth/refresh
POST /ai/process
POST /ai/sentiment
POST /ai/keywords
POST /ai/summary
```

See NetworkService.swift for request/response formats.

## Next Steps

1. **Customize UI:** Modify colors, fonts in Constants
2. **Add Backend:** Implement actual API endpoints
3. **Add Icons:** Create app icons and launch screens
4. **Test Features:** Try all user flows
5. **Add Analytics:** Integrate tracking if needed
6. **Setup CI/CD:** Automate builds and tests

## Troubleshooting

### "No such module 'SwiftUI'" error
- Make sure you're building for iOS, not macOS
- Clean and rebuild

### Core Data errors
- Reset simulator: Device → Erase All Content and Settings
- Check data model for errors

### Network errors
- Verify backend URL is correct
- Check network connectivity
- Review API response format

## Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Speech Framework Guide](https://developer.apple.com/documentation/speech)
- [Core Data Guide](https://developer.apple.com/documentation/coredata)

## Getting Help

- Check README.md for detailed documentation
- Review IMPLEMENTATION.md for architecture details
- Open GitHub issue for bugs
- Check Apple Developer Forums

## Demo Mode

To test without authentication:

```swift
// In AuthenticationViewModel.swift
func checkAuthenticationStatus() {
    // Add this for demo:
    isAuthenticated = true
    hasCompletedOnboarding = true
}
```

Happy coding! 🚀
