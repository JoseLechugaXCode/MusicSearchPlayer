import SwiftUI

@main
struct MusicSearchPlayerApp: App {
    
    @StateObject private var playerViewModel = PlayerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playerViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
