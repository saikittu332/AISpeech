import SwiftUI

/// Root content view with authentication flow
struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
                    .transition(.opacity)
            } else if authViewModel.hasCompletedOnboarding {
                LoginView(viewModel: authViewModel)
                    .transition(.slide)
            } else {
                OnboardingView(viewModel: authViewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: authViewModel.isAuthenticated)
        .animation(.easeInOut, value: authViewModel.hasCompletedOnboarding)
        .onAppear {
            authViewModel.checkAuthenticationStatus()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
