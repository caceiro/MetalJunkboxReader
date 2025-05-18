import SwiftUI

struct ArticleListOrganism: View {
    var body: some View {
        Text("[Article List Placeholder]")
            .foregroundColor(.gray)
            .padding()
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