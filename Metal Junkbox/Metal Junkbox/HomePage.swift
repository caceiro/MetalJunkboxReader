import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            ArticleListOrganism()
                .navigationTitle("Metal Junk Box")
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
} 