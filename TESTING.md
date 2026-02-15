# Testing AISpeech in iOS Simulator

This guide provides step-by-step instructions for testing the AISpeech application in an iOS simulator.

## Prerequisites

Before you begin testing, ensure you have:

- **macOS** 12.0 or later
- **Xcode** 13.0 or later installed
- Basic familiarity with Xcode interface

## Quick Start - Testing in Simulator

### 1. Open the Project

```bash
# Navigate to project directory
cd AISpeech

# Open in Xcode
xed .
```

Or double-click `Package.swift` to open in Xcode.

### 2. Select a Simulator

In Xcode's toolbar (top of window):

1. Click on the **device selector** (next to the scheme name "AISpeech")
2. Choose an iOS simulator from the list:
   - **iPhone 14** (recommended for testing)
   - **iPhone 14 Pro** (for testing with Dynamic Island)
   - **iPhone SE (3rd generation)** (for testing on smaller screens)
   - **iPad Pro** (for tablet testing)

### 3. Build and Run

**Option A: Using Keyboard Shortcut**
- Press `⌘R` (Command + R)

**Option B: Using Menu**
- Go to **Product → Run** in the menu bar

**Option C: Using Toolbar**
- Click the **Play button** (▶️) in the top-left corner

### 4. Wait for Build and Launch

1. Xcode will build the project (this may take 30-60 seconds on first build)
2. The iOS Simulator will launch automatically
3. The AISpeech app will install and open

## Testing the Application

### Initial Setup Testing

When you first launch the app, test the following flows:

#### 1. Onboarding Flow
- Verify onboarding screens display correctly
- Test swiping between screens
- Test the "Skip" button
- Ensure navigation to Login screen works

#### 2. Registration Flow
- Test creating a new account
- Verify validation errors display properly
- Check that successful registration navigates to main app
- **Note:** Registration requires backend API (may fail in demo mode)

#### 3. Login Flow
- Test logging in with credentials
- Verify error messages for invalid credentials
- Check "Remember me" functionality
- **Note:** Login requires backend API (may fail in demo mode)

### Core Features Testing

#### Speech Recognition
1. Navigate to the **Record** tab
2. Tap the microphone button
3. **Grant permissions** when prompted:
   - Microphone access
   - Speech recognition access
4. Speak into your Mac's microphone
5. Verify the text appears in real-time
6. Tap the microphone again to stop
7. Check that the transcript is accurate

**Testing Tips:**
- The simulator uses your Mac's microphone
- Ensure your Mac has microphone access in System Preferences
- Test in a quiet environment for best results

#### Text-to-Speech
1. After recording a transcript
2. Tap the **Play** or **Speaker** button
3. Verify audio plays through your Mac's speakers
4. Test different speech rates (in Settings)
5. Test volume controls

#### History View
1. Navigate to the **History** tab
2. Verify past transcripts are displayed
3. Test tapping on a transcript to view details
4. Test search functionality
5. Test delete/swipe actions
6. Verify empty state displays when no history exists

#### Settings View
1. Navigate to the **Settings** tab
2. Test language selection
3. Test speech rate adjustment
4. Test volume controls
5. Test appearance settings (Light/Dark/System)
6. Test logout functionality

## Testing Without Backend API

Since the app requires a backend API for some features, here's how to test without it:

### Features That Work Offline

✅ **These work in simulator without backend:**
- Speech recognition (uses Apple's Speech framework)
- Text-to-speech (uses AVSpeechSynthesizer)
- History/transcript storage (Core Data)
- Settings persistence (UserDefaults)
- UI navigation and interactions
- Dark mode switching

❌ **These require backend API:**
- User authentication (login/registration)
- AI processing (sentiment analysis)
- Keyword extraction
- Text summarization
- Cloud sync

### Demo Mode Testing

To test the app without a backend:

1. **Skip Authentication:**
   - Use the "Skip" button on onboarding
   - Or comment out authentication checks in code

2. **Test Local Features:**
   - Focus on speech recognition
   - Test text-to-speech
   - Test history management
   - Test settings

3. **Mock Network Responses:**
   - Modify ViewModels to return mock data
   - Test UI with different data states

## Advanced Testing Scenarios

### Testing Different Device Sizes

Test the app's responsive design:

1. **iPhone SE (Small Screen):**
   - Verify UI elements fit properly
   - Check text doesn't overflow
   - Test scrolling behavior

2. **iPhone 14 Pro (Standard):**
   - Default testing environment
   - Verify Dynamic Island doesn't obscure content

3. **iPhone 14 Pro Max (Large):**
   - Test with larger screen real estate
   - Verify UI scales appropriately

4. **iPad (Tablet):**
   - Test landscape and portrait orientations
   - Verify adaptive layouts work

### Testing Different iOS Versions

If you have multiple iOS SDK versions installed:

1. Open Xcode
2. Go to **Xcode → Preferences → Components**
3. Download additional simulator runtimes
4. Select older iOS versions from device selector
5. Test compatibility

### Testing Accessibility

1. **VoiceOver:**
   - Enable VoiceOver in Simulator: `Settings → Accessibility → VoiceOver`
   - Navigate the app using VoiceOver gestures
   - Verify all elements are labeled correctly

2. **Dynamic Type:**
   - Change text size: `Settings → Display & Brightness → Text Size`
   - Verify text scales appropriately
   - Check for text truncation

3. **Dark Mode:**
   - Toggle: `Settings → Display & Brightness → Dark`
   - Verify colors are readable
   - Check for contrast issues

### Testing Permissions

1. **Microphone Permission:**
   - First launch will prompt for access
   - To reset: `Simulator → Settings → Privacy → Microphone → AISpeech`
   - Test denying permission and handling

2. **Speech Recognition Permission:**
   - Will prompt after microphone permission
   - To reset: `Simulator → Settings → Privacy → Speech Recognition`
   - Test different permission states

### Testing Persistence

1. **Core Data:**
   - Record several transcripts
   - Close and reopen the app
   - Verify data persists

2. **User Defaults:**
   - Change settings
   - Close and reopen the app
   - Verify settings are saved

3. **Keychain:**
   - Login (if backend available)
   - Close and reopen the app
   - Verify authentication state persists

## Using Command Line for Testing

### Building from Command Line

```bash
# Build the project
xcodebuild -scheme AISpeech \
  -destination 'platform=iOS Simulator,name=iPhone 14' \
  build

# Build and run
xcodebuild -scheme AISpeech \
  -destination 'platform=iOS Simulator,name=iPhone 14' \
  -derivedDataPath ./build
```

### Running Tests from Command Line

```bash
# Run all tests
xcodebuild test \
  -scheme AISpeech \
  -destination 'platform=iOS Simulator,name=iPhone 14'

# Run specific test
xcodebuild test \
  -scheme AISpeech \
  -destination 'platform=iOS Simulator,name=iPhone 14' \
  -only-testing:AISpeechTests/SpeechViewModelTests

# Generate code coverage
xcodebuild test \
  -scheme AISpeech \
  -destination 'platform=iOS Simulator,name=iPhone 14' \
  -enableCodeCoverage YES
```

### Listing Available Simulators

```bash
# List all available simulators
xcrun simctl list devices

# List only booted simulators
xcrun simctl list devices | grep "Booted"
```

## Simulator Tips and Tricks

### Keyboard Shortcuts

- **⌘R** - Build and Run
- **⌘.** - Stop running
- **⌘⇧H** - Home button
- **⌘⇧K** - Toggle keyboard
- **⌘1** - 100% scale
- **⌘2** - 75% scale
- **⌘3** - 50% scale
- **⌘4** - 33% scale
- **⌘→** - Rotate right
- **⌘←** - Rotate left

### Simulator Menu Options

**Hardware Menu:**
- **Home** - Return to home screen
- **Lock** - Lock device
- **Shake Gesture** - Trigger shake
- **Touch ID** - Simulate Touch ID
- **Face ID** - Simulate Face ID

**Features Menu:**
- **Location** - Simulate GPS locations
- **Battery Level** - Set battery percentage
- **Network** - Simulate network conditions

### Debugging in Simulator

1. **Console Logs:**
   - View logs in Xcode's console (bottom panel)
   - Use `print()` statements for debugging
   - Check for errors and warnings

2. **Breakpoints:**
   - Click line number in Xcode to add breakpoint
   - Run app to pause at breakpoint
   - Inspect variables and step through code

3. **View Hierarchy:**
   - Click **Debug View Hierarchy** button while running
   - Inspect UI layout and constraints

4. **Memory Graph:**
   - Click **Debug Memory Graph** button
   - Identify memory leaks and retain cycles

## Troubleshooting

### Common Issues and Solutions

#### "No simulator available"
**Solution:**
- Go to **Xcode → Preferences → Components**
- Download the latest iOS simulator
- Restart Xcode

#### "Unable to boot simulator"
**Solution:**
```bash
# Shutdown all simulators
xcrun simctl shutdown all

# Erase simulator data
xcrun simctl erase all

# Reboot your Mac if issues persist
```

#### "Build failed" errors
**Solution:**
1. Clean build folder: `⌘⇧K` (Command + Shift + K)
2. Delete DerivedData:
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```
3. Restart Xcode
4. Try building again

#### "Microphone not working"
**Solution:**
1. Check Mac's System Preferences → Security & Privacy → Microphone
2. Ensure Xcode/Simulator has microphone access
3. In Simulator: Settings → Privacy → Microphone → AISpeech (toggle ON)
4. Restart simulator

#### "Speech recognition not working"
**Solution:**
1. Ensure internet connection (required for Apple's speech recognition)
2. Check permissions in Simulator settings
3. Try recording again
4. Check console for error messages

#### "App crashes on launch"
**Solution:**
1. Check console for crash logs
2. Verify all frameworks are properly linked
3. Reset simulator: Device → Erase All Content and Settings
4. Check for Core Data model version issues

#### "Simulator is slow"
**Solution:**
1. Close unused applications
2. Use smaller device (iPhone SE vs iPhone 14 Pro Max)
3. Reduce simulator scale (⌘3 for 50%)
4. Allocate more RAM to simulator in Xcode settings
5. Test on physical device if available

#### "Changes not appearing"
**Solution:**
1. Ensure you saved all files (⌘S)
2. Clean build folder (⌘⇧K)
3. Rebuild (⌘B)
4. Stop and restart app (⌘. then ⌘R)

### Resetting Simulator

If you encounter persistent issues:

**Option 1: Reset through Simulator**
1. Open Simulator
2. Go to **Device → Erase All Content and Settings**
3. Confirm reset

**Option 2: Reset through Command Line**
```bash
# Erase specific simulator
xcrun simctl erase "iPhone 14"

# Erase all simulators
xcrun simctl erase all
```

## Testing Checklist

Use this checklist to ensure comprehensive testing:

### UI/UX Testing
- [ ] All screens load correctly
- [ ] Navigation between screens works
- [ ] Buttons respond to taps
- [ ] Text input fields work
- [ ] Scrolling is smooth
- [ ] Animations play correctly
- [ ] Dark mode displays properly
- [ ] Light mode displays properly

### Functional Testing
- [ ] Speech recognition works
- [ ] Text-to-speech works
- [ ] Transcripts are saved
- [ ] History displays correctly
- [ ] Settings persist after app restart
- [ ] Search functionality works
- [ ] Delete operations work

### Permission Testing
- [ ] Microphone permission requested
- [ ] Speech recognition permission requested
- [ ] Permission denial handled gracefully
- [ ] Permission grant enables features

### Edge Case Testing
- [ ] Test with no internet connection
- [ ] Test with very long transcripts
- [ ] Test with special characters
- [ ] Test with different languages
- [ ] Test with empty states
- [ ] Test rapid button tapping

### Accessibility Testing
- [ ] VoiceOver navigation works
- [ ] Dynamic Type scaling works
- [ ] High contrast mode works
- [ ] Voice Control works
- [ ] All buttons have labels

### Performance Testing
- [ ] App launches quickly
- [ ] No lag during recording
- [ ] Smooth scrolling in history
- [ ] No memory leaks
- [ ] Battery usage is reasonable

## Best Practices

1. **Test Early and Often:**
   - Test after every major change
   - Don't wait until the end to test

2. **Test on Multiple Devices:**
   - Different screen sizes
   - Different iOS versions
   - Both iPhone and iPad

3. **Test Edge Cases:**
   - No internet connection
   - No microphone access
   - Empty data states
   - Maximum data loads

4. **Use Real Data:**
   - Don't just test with "test" text
   - Use realistic content
   - Test with long and short inputs

5. **Document Issues:**
   - Take screenshots of bugs
   - Note steps to reproduce
   - Check console logs
   - Create GitHub issues

## Next Steps

After testing in simulator:

1. **Test on Physical Device:**
   - Connect iPhone via USB
   - Select device in Xcode
   - Build and run on device
   - Test real-world usage

2. **Automated Testing:**
   - Write unit tests for ViewModels
   - Create UI tests for critical flows
   - Set up continuous integration

3. **Beta Testing:**
   - Use TestFlight for beta distribution
   - Gather feedback from users
   - Iterate based on feedback

4. **Profiling:**
   - Use Instruments for performance profiling
   - Check memory usage
   - Optimize slow operations

## Additional Resources

- [Apple's Simulator Documentation](https://developer.apple.com/documentation/xcode/running-your-app-in-simulator-or-on-a-device)
- [Testing iOS Apps Guide](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/)
- [Xcode Help](https://help.apple.com/xcode/)
- [iOS Simulator User Guide](https://help.apple.com/simulator/mac/current/)

## Support

If you encounter issues not covered in this guide:

- Check the [README.md](README.md) for general documentation
- Review [QUICKSTART.md](QUICKSTART.md) for setup instructions
- Open a [GitHub Issue](https://github.com/saikittu332/AISpeech/issues)
- Contact: support@aispeech.com

---

Happy Testing! 🧪📱
