import SwiftUI

struct SearchView: View {

    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject var playerViewModel: PlayerViewModel

    var body: some View {
        NavigationView {
            ZStack {
             
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
               
                    SearchBarView(text: $viewModel.searchText) {
                        viewModel.onSearchTextChanged()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                
                    ZStack {
                        if viewModel.isLoading {
                            LoadingView(message: "Buscando…")
                        } else if let error = viewModel.errorMessage {
                            ErrorView(message: error)
                        } else if viewModel.songs.isEmpty && !viewModel.searchText.isEmpty {
                            EmptyStateView()
                        } else if viewModel.songs.isEmpty {
                            WelcomeView()
                        } else {
                            songList
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                   
                    if playerViewModel.currentTrack != nil {
                        Color.clear.frame(height: 72)
                    }
                }
            }
            .navigationTitle("Busca tu canción...")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .navigationViewStyle(.stack)
    }

    private var songList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.songs) { song in
                    SongRowView(song: song) {
                        playerViewModel.play(song: song)
                    }
                    .padding(.horizontal, 16)

                    Divider()
                        .background(Color.white.opacity(0.08))
                        .padding(.leading, 76)
                }
            }
            .padding(.top, 8)
        }
    }
}

private struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 52))
                .foregroundColor(.appAccent)
            Text("Busca tu canción favorita")
                .font(.title3).fontWeight(.semibold)
                .foregroundColor(.white)
            Text("Escribe el nombre del artista o de la canción")
                .font(.subheadline)
                .foregroundColor(.appSubtitle)
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "music.note.list")
                .font(.system(size: 48))
                .foregroundColor(.appSubtitle)
            Text("Sin resultados obtenidos")
                .font(.headline)
                .foregroundColor(.white)
            Text("Intenta con algo diferente")
                .font(.subheadline)
                .foregroundColor(.appSubtitle)
        }
    }
}
