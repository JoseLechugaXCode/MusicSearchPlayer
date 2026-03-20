import Foundation


final class NetworkManager {


    static let shared = NetworkManager()
    private init() {}

    func fetch<T: Decodable>(_ type: T.Type = T.self, from url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

         
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw AppError.networkError(
                    NSError(domain: "HTTP", code: httpResponse.statusCode)
                )
            }

           
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return decoded
            } catch {
                throw AppError.decodingError(error)
            }

        } catch let appError as AppError {
            throw appError
        } catch {
            throw AppError.networkError(error)
        }
    }

    
    func fetch<T: Decodable>(_ type: T.Type = T.self, from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw AppError.invalidURL
        }
        return try await fetch(type, from: url)
    }
}
