import SwiftUI

// MARK: - Brand Colors
extension Color {
    static let brandBackground = Color.black
    static let brandAccent = Color(red: 1.0, green: 0.84, blue: 0.0) // #FFD700
}

// MARK: - Typography
struct BrandFont {
    static let headline = Font.system(size: 28, weight: .bold, design: .default)
    static let body = Font.system(size: 17, weight: .regular, design: .default)
}

// MARK: - Atoms
struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.brandAccent)
                .cornerRadius(10)
        }
    }
} 