import SwiftUI

struct EventsPage: View {
    var body: some View {
        NavigationView {
            EventPlaceholderOrganism()
                .navigationTitle("Events")
        }
    }
}

struct EventsPage_Previews: PreviewProvider {
    static var previews: some View {
        EventsPage()
    }
} 