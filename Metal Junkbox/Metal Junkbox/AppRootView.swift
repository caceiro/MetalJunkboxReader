import SwiftUI

struct AppRootView: View {
    var body: some View {
        TabView {
            HomePage()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            FavoritesPage()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            EventsPage()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
        }
        .accentColor(Color("AccentColor"))
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
} 