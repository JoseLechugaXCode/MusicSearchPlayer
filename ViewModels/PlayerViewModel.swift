import Foundation
import Combine

@MainActor
final class PlayerViewModel: ObservableObject {

   
    @Published var currentTrack: Song? = nil
    @Published var isPlayerPresented: Bool = false


    @Published var lyrics: String = ""
    @Published var isLoadingLyrics: Bool = false
    @Published var lyricsError: String? = nil

  
    @Published var isPlaying: Bool = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0

 
    let audioPlayer: AudioPlayerService
    private let lyricsService: LyricsService
    private var cancellables = Set<AnyCancellable>()
    private var lyricsTask: Task<Void, Never>?

    init(
        audioPlayer: AudioPlayerService = AudioPlayerService(),
        lyricsService: LyricsService = LyricsService()
    ) {
        self.audioPlayer = audioPlayer
        self.lyricsService = lyricsService

       
        audioPlayer.$isPlaying
            .receive(on: DispatchQueue.main)
            .assign(to: &$isPlaying)

        audioPlayer.$currentTime
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentTime)

        audioPlayer.$duration
            .receive(on: DispatchQueue.main)
            .assign(to: &$duration)
    }

    var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }

    func play(song: Song) {
   
        if currentTrack == song {
            isPlayerPresented = true
            return
        }

        currentTrack = song
        lyrics = ""
        lyricsError = nil

        if let urlString = song.previewUrl, let url = URL(string: urlString) {
            audioPlayer.load(url: url)
        }

        isPlayerPresented = true
        fetchLyrics(for: song)
    }

    func togglePlayPause() {
        audioPlayer.togglePlayPause()
    }

    func seek(to progress: Double) {
        audioPlayer.seek(to: progress)
    }


    func expandPlayer() {
        isPlayerPresented = true
    }


    private func fetchLyrics(for song: Song) {
        lyricsTask?.cancel()
        isLoadingLyrics = true
        lyricsError = nil
        lyrics = ""

        lyricsTask = Task {
            do {
                let text = try await lyricsService.fetchLyrics(
                    artist: song.artistName,
                    title: song.trackName
                )
                if !Task.isCancelled {
                    lyrics = text
                }
            } catch let error as AppError {
                if !Task.isCancelled {
                    lyricsError = error.errorDescription
                }
            } catch {
                if !Task.isCancelled {
                    lyricsError = AppError.unknown.errorDescription
                }
            }
            isLoadingLyrics = false
        }
    }
}
