import SwiftUI

struct ArticleDetailPage: View, Identifiable {
    let id = UUID()
    let article: Article
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let urlString = article.featuredImageURL, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.gray.opacity(0.2)
                                .frame(height: 220)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 220)
                                .clipped()
                        case .failure:
                            Color.gray.opacity(0.2)
                                .frame(height: 220)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                HStack(alignment: .top) {
                    Text(article.title.rendered.htmlStripped)
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.brandAccent)
                    Spacer()
                    FavoriteButtonAtom(isFavorite: isFavorite, action: onFavoriteToggle)
                }
                Text(article.date.prefix(10))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Divider()
                HTMLText(html: article.content.rendered)
            }
            .padding()
        }
        .background(Color.brandBackground.ignoresSafeArea())
    }
}

// MARK: - HTMLText View
struct HTMLText: UIViewRepresentable {
    let html: String
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.textColor = UIColor.white
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        guard let data = html.data(using: .utf8) else { return }
        if let attributed = try? NSAttributedString(data: data, options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ], documentAttributes: nil) {
            uiView.attributedText = attributed
        } else {
            uiView.text = html
        }
    }
} 