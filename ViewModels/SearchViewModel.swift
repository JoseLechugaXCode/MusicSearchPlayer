import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {

   
    @Published var searchText: String = ""
    @Published var songs: [Song] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

  
    private let searchService: MusicSearchService
    private var searchTask: Task<Void, Never>?

    init(searchService: MusicSearchService = MusicSearchService()) {
        self.searchService = searchService
    }

   
    func onSearchTextChanged() {
   
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard query.count >= 2 else {
            songs = []
            errorMessage = nil
            return
        }

      
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 400_000_000)
            guard !Task.isCancelled else { return }
            await performSearch(query: query)
        }
    }


    private func performSearch(query: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let results = try await searchService.search(query: query)
    
            if !Task.isCancelled {
                songs = results
            }
        } catch let error as AppError {
            if !Task.isCancelled {
                songs = []
                errorMessage = error.errorDescription
            }
        } catch {
            if !Task.isCancelled {
                songs = []
                errorMessage = AppError.unknown.errorDescription
            }
        }

        isLoading = false
    }
}
