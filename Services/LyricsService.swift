import Foundation

final class LyricsService {

    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

   
    func fetchLyrics(artist: String, title: String) async throws -> String {
      
        guard
            let encodedArtist = artist.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let encodedTitle  = title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: "https://api.lyrics.ovh/v1/\(encodedArtist)/\(encodedTitle)")
        else {
            throw AppError.invalidURL
        }

       
        do {
            let response: LyricsResponse = try await network.fetch(from: url)
            let cleaned = response.lyrics.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleaned.isEmpty { throw AppError.lyricsNotFound }
            return cleaned
        } catch AppError.decodingError {

            throw AppError.lyricsNotFound
        }
    }
}
