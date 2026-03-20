import Foundation


struct LyricsResponse: Decodable {
    let lyrics: String
}


struct LyricsErrorResponse: Decodable {
    let error: String
}
