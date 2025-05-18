import Foundation

struct Article: Identifiable, Decodable, Equatable {
    let id: Int
    let title: RenderedText
    let excerpt: RenderedText
    let date: String
    let content: RenderedText
    let featuredImageURL: String?
    
    struct RenderedText: Decodable, Equatable {
        let rendered: String
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, excerpt, date, content
        case embedded = "_embedded"
    }
    
    private enum EmbeddedKeys: String, CodingKey {
        case featuredmedia = "wp:featuredmedia"
    }
    
    private enum MediaKeys: String, CodingKey {
        case sourceURL = "source_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(RenderedText.self, forKey: .title)
        excerpt = try container.decode(RenderedText.self, forKey: .excerpt)
        date = try container.decode(String.self, forKey: .date)
        content = try container.decode(RenderedText.self, forKey: .content)
        // Parse featured image from _embedded
        if let embedded = try? container.nestedContainer(keyedBy: EmbeddedKeys.self, forKey: .embedded),
           var mediaArray = try? embedded.nestedUnkeyedContainer(forKey: .featuredmedia),
           let media = try? mediaArray.nestedContainer(keyedBy: MediaKeys.self) {
            featuredImageURL = try? media.decode(String.self, forKey: .sourceURL)
        } else {
            featuredImageURL = nil
        }
    }
} 