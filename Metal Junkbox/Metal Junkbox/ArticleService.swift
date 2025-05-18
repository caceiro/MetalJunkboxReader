import Foundation
import Combine

class ArticleService {
    static let shared = ArticleService()
    private let baseURL = URL(string: "https://metaljunkbox.com/wp-json/wp/v2/posts")!
    
    func fetchArticles(category: String? = nil, page: Int = 1, perPage: Int = 10) -> AnyPublisher<[Article], Error> {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var queryItems = [
            URLQueryItem(name: "_embed", value: "true"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        if let category = category {
            queryItems.append(URLQueryItem(name: "categories", value: category))
        }
        urlComponents.queryItems = queryItems
        let url = urlComponents.url!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Article].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
} 