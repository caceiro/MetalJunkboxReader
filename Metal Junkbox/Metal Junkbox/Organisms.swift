import SwiftUI

struct ArticleListOrganism: View {
    @StateObject private var viewModel = ArticleListViewModel()
    @State private var selectedArticle: Article?
    @State private var favoriteIDs: Set<Int> = []
    
    var body: some View {
        content
            .onAppear {
                if viewModel.articles.isEmpty {
                    viewModel.fetchArticles()
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.articles.isEmpty {
            loadingView
        } else if let error = viewModel.error {
            errorView(error)
        } else {
            articleListView
        }
    }

    private var loadingView: some View {
        ProgressView("Loading articles...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(_ error: Error) -> some View {
        VStack {
            Text("Failed to load articles: \(error.localizedDescription)")
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
            PrimaryButton(title: "Retry") {
                viewModel.refresh()
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var articleListView: some View {
        List {
            ForEach(viewModel.articles) { article in
                Button(action: { selectedArticle = article }) {
                    ArticleCardMolecule(
                        article: article,
                        isFavorite: favoriteIDs.contains(article.id),
                        onFavoriteToggle: {
                            if favoriteIDs.contains(article.id) {
                                favoriteIDs.remove(article.id)
                            } else {
                                favoriteIDs.insert(article.id)
                            }
                        }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .onAppear {
                    if article == viewModel.articles.last {
                        viewModel.fetchArticles()
                    }
                }
            }
            if viewModel.isLoading && !viewModel.articles.isEmpty {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(PlainListStyle())
        .refreshable {
            viewModel.refresh()
        }
        .sheet(item: $selectedArticle) { article in
            ArticleDetailPage(
                article: article,
                isFavorite: favoriteIDs.contains(article.id),
                onFavoriteToggle: {
                    if favoriteIDs.contains(article.id) {
                        favoriteIDs.remove(article.id)
                    } else {
                        favoriteIDs.insert(article.id)
                    }
                }
            )
        }
    }
}

struct FavoritesListOrganism: View {
    var body: some View {
        Text("[Favorites List Placeholder]")
            .foregroundColor(.gray)
            .padding()
    }
}

struct EventPlaceholderOrganism: View {
    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .font(.system(size: 48))
                .foregroundColor(.yellow)
            Text("Events coming soon!")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

// MARK: - Molecules
struct ArticleCardMolecule: View {
    let article: Article
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let urlString = article.featuredImageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.opacity(0.2)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipped()
                            .cornerRadius(8)
                    case .failure:
                        Color.gray.opacity(0.2)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(article.title.rendered.htmlStripped)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(article.date.prefix(10))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            FavoriteButtonAtom(isFavorite: isFavorite, action: onFavoriteToggle)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Atoms
struct FavoriteButtonAtom: View {
    let isFavorite: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundColor(isFavorite ? .yellow : .gray)
                .imageScale(.large)
                .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

// MARK: - Helpers
extension String {
    var htmlStripped: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributed.string
        }
        return self
    }
} 