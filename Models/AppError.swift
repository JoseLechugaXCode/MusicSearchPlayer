import Foundation

enum AppError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case noResults
    case lyricsNotFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL requerida es inválida."
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .decodingError:
            return "Error en la respuesta del servidor."
        case .noResults:
            return "No existen resultados de la búsqueda."
        case .lyricsNotFound:
            return "Letra no disponible para esta canción."
        case .unknown:
            return "Ocurrió un error desconocido."
        }
    }
}
