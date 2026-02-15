import SwiftUI

/// Main entry point for the AISpeech application
@main
struct AISpeechApp: App {
    // Core Data persistence controller
    @StateObject private var persistenceController = PersistenceController.shared
    
    // App-wide state management
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
                .preferredColorScheme(appState.colorScheme)
        }
    }
}
