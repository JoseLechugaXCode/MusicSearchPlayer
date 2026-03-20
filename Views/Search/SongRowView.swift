import SwiftUI

struct SongRowView: View {

    let song: Song
    let onTap: () -> Void

    @EnvironmentObject var playerViewModel: PlayerViewModel

   
    private var isCurrentTrack: Bool {
        playerViewModel.currentTrack?.id == song.id
    }

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
          
                AsyncImage(url: URL(string: song.artworkUrl100 ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        Image(systemName: "music.note")
                            .foregroundColor(.appSubtitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.appSurface)
                    @unknown default:
                        Color.appSurface
                    }
                }
                .frame(width: 52, height: 52)
                .cornerRadius(6)
                .clipped()

            
                VStack(alignment: .leading, spacing: 4) {
                    Text(song.trackName)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(isCurrentTrack ? .appAccent : .white)
                        .lineLimit(1)

                    Text(song.artistName)
                        .font(.system(size: 13))
                        .foregroundColor(.appSubtitle)
                        .lineLimit(1)
                }

                Spacer()

               
                if isCurrentTrack && playerViewModel.isPlaying {
                    PlayingBarsView()
                        .frame(width: 20, height: 16)
                } else {
                    Text(song.formattedDuration)
                        .font(.system(size: 12))
                        .foregroundColor(.appSubtitle)
                }
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlayingBarsView: View {

    @State private var animating = false

  
    private let heights: [CGFloat] = [0.4, 1.0, 0.6]
    private let delays: [Double]   = [0.0, 0.2, 0.1]

    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(0..<3, id: \.self) { i in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.appAccent)
                    .frame(width: 3, height: animating ? 16 * heights[i] : 4)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(delays[i]),
                        value: animating
                    )
            }
        }
        .onAppear { animating = true }
    }
}
