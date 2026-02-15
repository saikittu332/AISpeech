import SwiftUI

/// Settings view for app preferences
struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @StateObject private var authViewModel = AuthenticationViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showingLogoutAlert = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationView {
            Form {
                // Profile Section
                Section(header: Text("Profile")) {
                    if let user = authViewModel.currentUser {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // Appearance Section
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $viewModel.isDarkMode)
                        .onChange(of: viewModel.isDarkMode) { newValue in
                            appState.isDarkMode = newValue
                        }
                    
                    HStack {
                        Text("Font Size")
                        Spacer()
                        Text("\(Int(viewModel.fontSize))")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $viewModel.fontSize, in: 12...24, step: 1)
                }
                
                // Speech Settings
                Section(header: Text("Speech")) {
                    Picker("Language", selection: $viewModel.selectedLanguage) {
                        ForEach(Constants.Speech.supportedLanguages, id: \.self) { language in
                            Text(languageName(for: language))
                                .tag(language)
                        }
                    }
                    
                    HStack {
                        Text("Speech Rate")
                        Spacer()
                        Text(String(format: "%.1f", viewModel.speechRate))
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $viewModel.speechRate, in: 0.1...1.0, step: 0.1)
                    
                    Toggle("Auto-process with AI", isOn: $viewModel.autoProcessWithAI)
                }
                
                // Notifications Section
                Section(header: Text("Preferences")) {
                    Toggle("Enable Haptics", isOn: $viewModel.enableHaptics)
                    Toggle("Enable Notifications", isOn: $viewModel.enableNotifications)
                }
                
                // Privacy & Security
                Section(header: Text("Privacy & Security")) {
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    NavigationLink(destination: TermsOfServiceView()) {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                }
                
                // About
                Section(header: Text("About")) {
                    Button(action: { showingAbout = true }) {
                        HStack {
                            Label("About AISpeech", systemImage: "info.circle")
                            Spacer()
                            Text("v\(Constants.App.version)")
                                .foregroundColor(.secondary)
                        }
                    }
                    .foregroundColor(.primary)
                    
                    Button(action: {
                        viewModel.resetToDefaults()
                    }) {
                        Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                    }
                }
                
                // Account
                Section {
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        Label("Log Out", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Log Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    authViewModel.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
    
    private func languageName(for code: String) -> String {
        let locale = Locale(identifier: code)
        return locale.localizedString(forLanguageCode: code) ?? code
    }
}

struct AboutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Constants.UI.spacing * 2) {
                    Image(systemName: "waveform.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.blue)
                    
                    Text("AISpeech")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Version \(Constants.App.version) (\(Constants.App.buildNumber))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: Constants.UI.spacing) {
                        Text("Features")
                            .font(.headline)
                        
                        FeatureRow(icon: "mic.fill", title: "Speech Recognition", description: "Real-time speech-to-text conversion")
                        FeatureRow(icon: "brain.head.profile", title: "AI Processing", description: "Advanced text analysis and insights")
                        FeatureRow(icon: "speaker.wave.2", title: "Text-to-Speech", description: "Natural voice synthesis")
                        FeatureRow(icon: "square.stack.3d.up", title: "History", description: "Save and manage transcripts")
                    }
                    .padding()
                    
                    Divider()
                        .padding(.vertical)
                    
                    Text("© 2026 AISpeech. All rights reserved.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: Constants.UI.spacing) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.spacing) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Last updated: \(Date().formatted(date: .long, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text("Data Collection")
                    .font(.headline)
                    .padding(.top)
                
                Text("AISpeech collects and processes voice data to provide speech recognition services. All audio data is processed securely and is not shared with third parties without your consent.")
                    .font(.body)
                
                Text("Data Storage")
                    .font(.headline)
                    .padding(.top)
                
                Text("Transcription history is stored locally on your device using Core Data. You can delete your data at any time from the History view.")
                    .font(.body)
                
                Text("Permissions")
                    .font(.headline)
                    .padding(.top)
                
                Text("The app requires microphone access for speech recognition. Speech recognition permission is also required to use the transcription features.")
                    .font(.body)
                
                Text("Contact")
                    .font(.headline)
                    .padding(.top)
                
                Text("For privacy concerns or questions, please contact us at privacy@aispeech.com")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.UI.spacing) {
                Text("Terms of Service")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Last updated: \(Date().formatted(date: .long, time: .omitted))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Divider()
                
                Text("Acceptance of Terms")
                    .font(.headline)
                    .padding(.top)
                
                Text("By using AISpeech, you agree to these terms of service. If you do not agree, please do not use the application.")
                    .font(.body)
                
                Text("Use of Service")
                    .font(.headline)
                    .padding(.top)
                
                Text("AISpeech is provided for personal and professional use. You agree not to misuse the service or use it for illegal purposes.")
                    .font(.body)
                
                Text("Accuracy")
                    .font(.headline)
                    .padding(.top)
                
                Text("While we strive for high accuracy in speech recognition and AI processing, we cannot guarantee 100% accuracy. Always verify important transcriptions.")
                    .font(.body)
                
                Text("Changes to Terms")
                    .font(.headline)
                    .padding(.top)
                
                Text("We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.")
                    .font(.body)
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppState())
    }
}
