import Foundation
import Combine

class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var page = 1
    @Published var hasMore = true
    
    private var cancellables = Set<AnyCancellable>()
    private let perPage = 10
    
    func fetchArticles(reset: Bool = false) {
        if isLoading { return }
        if reset {
            page = 1
            hasMore = true
            articles = []
        }
        guard hasMore else { return }
        isLoading = true
        error = nil
        ArticleService.shared.fetchArticles(page: page, perPage: perPage)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure(let err):
                    self.error = err
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] newArticles in
                guard let self = self else { return }
                if newArticles.count < self.perPage {
                    self.hasMore = false
                }
                self.articles.append(contentsOf: newArticles)
                self.page += 1
            })
            .store(in: &cancellables)
    }
    
    func refresh() {
        fetchArticles(reset: true)
    }
} 