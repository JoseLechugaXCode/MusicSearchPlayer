import Foundation

struct ITunesSearchResponse: Decodable {
    let resultCount: Int
    let results: [Song]
}

struct Song: Identifiable, Decodable, Equatable {

    let id: Int
    let trackName: String
    let artistName: String
    let collectionName: String?        // Album name
    let artworkUrl100: String?         // 100x100 artwork URL
    let previewUrl: String?            // 30-second audio preview
    let trackTimeMillis: Int?          // Duration in milliseconds
    let primaryGenreName: String?


    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case collectionName
        case artworkUrl100
        case previewUrl
        case trackTimeMillis
        case primaryGenreName
    }




    var highResArtworkUrl: String? {
        artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600")
    }


    var formattedDuration: String {
        guard let ms = trackTimeMillis else { return "--:--" }
        let totalSeconds = ms / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
