import SwiftUI

struct FavoritesPage: View {
    var body: some View {
        NavigationView {
            FavoritesListOrganism()
                .navigationTitle("Favorites")
        }
    }
}

struct FavoritesPage_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesPage()
    }
} 