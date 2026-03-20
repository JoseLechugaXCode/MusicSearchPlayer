import SwiftUI

struct ContentView: View {
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
       
            SearchView()

        
            if playerViewModel.currentTrack != nil {
                MiniPlayerView()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: playerViewModel.currentTrack != nil)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    
        .sheet(isPresented: $playerViewModel.isPlayerPresented) {
            PlayerView()
                .environmentObject(playerViewModel)
        }
    }
}
