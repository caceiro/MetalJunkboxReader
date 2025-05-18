import Foundation

struct Article: Identifiable, Decodable, Equatable {
    let id: Int
    let title: RenderedText
    let excerpt: RenderedText
    let date: String
    let featured_media_url: String?
    let content: RenderedText
    
    struct RenderedText: Decodable, Equatable {
        let rendered: String
    }
} 