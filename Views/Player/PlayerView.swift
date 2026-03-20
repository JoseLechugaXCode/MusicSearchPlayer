import SwiftUI

struct PlayerView: View {

    @EnvironmentObject var playerViewModel: PlayerViewModel
    @State private var selectedTab: PlayerTab = .player
    @Environment(\.dismiss) private var dismiss

    enum PlayerTab: String, CaseIterable {
        case player = "Reproduciendo"
        case lyrics = "Letra"
    }

    var body: some View {
        ZStack {
        
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {

                Capsule()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 36, height: 4)
                    .padding(.top, 12)

                
                Picker("", selection: $selectedTab) {
                    ForEach(PlayerTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 24)
                .padding(.top, 16)

              
                if selectedTab == .player {
                    PlayerControlsSection()
                        .transition(.opacity)
                } else {
                    LyricsView()
                        .transition(.opacity)
                }
            }
        }
        .preferredColorScheme(.dark)
        .animation(.easeInOut(duration: 0.25), value: selectedTab)
    }
}

private struct PlayerControlsSection: View {

    @EnvironmentObject var vm: PlayerViewModel

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

        
            artworkView
                .padding(.horizontal, 40)

            Spacer(minLength: 24)

          
            VStack(spacing: 6) {
                Text(vm.currentTrack?.trackName ?? "")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 32)

                Text(vm.currentTrack?.artistName ?? "")
                    .font(.system(size: 16))
                    .foregroundColor(.appSubtitle)
            }

            Spacer(minLength: 20)

          
            PlayerProgressView()
                .padding(.horizontal, 32)

            Spacer(minLength: 16)

         
            PlaybackControlsView()
                .padding(.horizontal, 40)

            Spacer()
        }
    }

    private var artworkView: some View {
        AsyncImage(url: URL(string: vm.currentTrack?.highResArtworkUrl ?? "")) { phase in
            switch phase {
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fit)
            default:
                ZStack {
                    Color.appSurface
                    Image(systemName: "music.note")
                        .font(.system(size: 60))
                        .foregroundColor(.appSubtitle)
                }
            }
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 10)
      
        .scaleEffect(vm.isPlaying ? 1.0 : 0.88)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: vm.isPlaying)
    }
}

struct PlayerProgressView: View {

    @EnvironmentObject var vm: PlayerViewModel
    @State private var isDragging: Bool = false
    @State private var dragProgress: Double = 0

    var displayProgress: Double {
        isDragging ? dragProgress : vm.progress
    }

    var body: some View {
        VStack(spacing: 6) {
          
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                  
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 4)

                   
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white)
                        .frame(width: geo.size.width * displayProgress, height: 4)

                  
                    Circle()
                        .fill(Color.white)
                        .frame(width: isDragging ? 14 : 10, height: isDragging ? 14 : 10)
                        .offset(x: geo.size.width * displayProgress - (isDragging ? 7 : 5))
                        .animation(.spring(response: 0.2), value: isDragging)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDragging = true
                            dragProgress = max(0, min(1, value.location.x / geo.size.width))
                        }
                        .onEnded { _ in
                            vm.seek(to: dragProgress)
                            isDragging = false
                        }
                )
            }
            .frame(height: 20)

           
            HStack {
                Text(formatTime(vm.currentTime))
                Spacer()
                Text(formatTime(vm.duration))
            }
            .font(.system(size: 12))
            .foregroundColor(.appSubtitle)
        }
    }

    private func formatTime(_ seconds: Double) -> String {
        guard seconds.isFinite && seconds > 0 else { return "0:00" }
        let s = Int(seconds)
        return String(format: "%d:%02d", s / 60, s % 60)
    }
}

struct PlaybackControlsView: View {

    @EnvironmentObject var vm: PlayerViewModel

    var body: some View {
        HStack(spacing: 0) {
            Spacer()

           
            Button {
                vm.seek(to: max(0, vm.progress - (15 / max(vm.duration, 1))))
            } label: {
                Image(systemName: "gobackward.15")
                    .font(.system(size: 28))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

           
            Button(action: vm.togglePlayPause) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 64, height: 64)
                    Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.black)
                        .offset(x: vm.isPlaying ? 0 : 2)
                }
            }
            .scaleEffect(vm.isPlaying ? 1.0 : 0.95)
            .animation(.spring(response: 0.2), value: vm.isPlaying)

            Spacer()

          
            Button {
                vm.seek(to: min(1, vm.progress + (15 / max(vm.duration, 1))))
            } label: {
                Image(systemName: "goforward.15")
                    .font(.system(size: 28))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()
        }
    }
}
