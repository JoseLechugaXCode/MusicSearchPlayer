import SwiftUI

struct MiniPlayerView: View {

    @EnvironmentObject var vm: PlayerViewModel
    @State private var isTapped: Bool = false

    var body: some View {
        VStack(spacing: 0) {
       
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Color.white.opacity(0.15)
                    Color.appAccent.frame(width: geo.size.width * vm.progress)
                }
            }
            .frame(height: 2)

            HStack(spacing: 12) {
           
                AsyncImage(url: URL(string: vm.currentTrack?.artworkUrl100 ?? "")) { phase in
                    if case .success(let img) = phase {
                        img.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Color.appSurface
                    }
                }
                .frame(width: 44, height: 44)
                .cornerRadius(6)
                .clipped()

         
                VStack(alignment: .leading, spacing: 2) {
                    Text(vm.currentTrack?.trackName ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(vm.currentTrack?.artistName ?? "")
                        .font(.system(size: 12))
                        .foregroundColor(.appSubtitle)
                        .lineLimit(1)
                }

                Spacer()

                Button(action: vm.togglePlayPause) {
                    Image(systemName: vm.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(

            ZStack {
                Color.appSurface
                Color.white.opacity(0.04)
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            vm.expandPlayer()
        }
        .padding(.bottom, bottomPadding)
    }

    private var bottomPadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let insets = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
        return insets > 0 ? insets : 0
    }
}
