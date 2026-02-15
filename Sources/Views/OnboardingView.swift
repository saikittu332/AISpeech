import SwiftUI

/// Onboarding view for first-time users
struct OnboardingView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Welcome to AISpeech",
            description: "Transform your voice into text with powerful AI-driven speech recognition",
            imageName: "waveform.circle.fill",
            color: .blue
        ),
        OnboardingPage(
            title: "Real-time Transcription",
            description: "Get instant, accurate transcriptions of your speech with high confidence scores",
            imageName: "text.bubble.fill",
            color: .green
        ),
        OnboardingPage(
            title: "AI-Powered Analysis",
            description: "Analyze sentiment, extract keywords, and generate summaries automatically",
            imageName: "brain.head.profile",
            color: .purple
        ),
        OnboardingPage(
            title: "Text-to-Speech",
            description: "Convert text back to natural-sounding speech in multiple languages",
            imageName: "speaker.wave.3.fill",
            color: .orange
        )
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        viewModel.skipOnboarding()
                    }
                    .font(.body)
                    .padding()
                }
                
                // Page indicator
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                
                // Continue/Get Started button
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        viewModel.completeOnboarding()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.UI.buttonHeight)
                        .background(Color.blue)
                        .cornerRadius(Constants.UI.cornerRadius)
                }
                .padding(.horizontal, Constants.UI.padding)
                .padding(.bottom, Constants.UI.padding)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: Constants.UI.spacing * 2) {
            Spacer()
            
            Image(systemName: page.imageName)
                .font(.system(size: 100))
                .foregroundColor(page.color)
                .padding(.bottom, Constants.UI.spacing)
            
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(page.description)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Constants.UI.padding * 2)
            
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: AuthenticationViewModel())
    }
}
