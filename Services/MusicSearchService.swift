import Foundation

final class MusicSearchService {

    private let network: NetworkManager

    init(network: NetworkManager = .shared) {
        self.network = network
    }

  
    func search(query: String, limit: Int = 25) async throws -> [Song] {
       
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw AppError.invalidURL
        }

        let urlString = "https://itunes.apple.com/search?term=\(encoded)&media=music&entity=song&limit=\(limit)"

        let response: ITunesSearchResponse = try await network.fetch(from: urlString)

        if response.results.isEmpty {
            throw AppError.noResults
        }

        return response.results
    }
}
