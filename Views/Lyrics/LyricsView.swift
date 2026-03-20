import SwiftUI

struct LyricsView: View {

    @EnvironmentObject var vm: PlayerViewModel

    var body: some View {
        Group {
            if vm.isLoadingLyrics {
                LoadingView(message: "Fetching lyrics…")
            } else if let error = vm.lyricsError {
                ErrorView(message: error)
            } else if vm.lyrics.isEmpty {
                noLyricsView
            } else {
                lyricsScrollView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var lyricsScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
              
                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.currentTrack?.trackName ?? "")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text(vm.currentTrack?.artistName ?? "")
                        .font(.system(size: 14))
                        .foregroundColor(.appSubtitle)
                }
                .padding(.bottom, 24)

              
                Text(vm.lyrics)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(8)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.vertical, 24)
        }
    }

    private var noLyricsView: some View {
        VStack(spacing: 12) {
            Image(systemName: "text.bubble")
                .font(.system(size: 48))
                .foregroundColor(.appSubtitle)
            Text("No lyrics available")
                .font(.headline)
                .foregroundColor(.white)
        }
    }
}
