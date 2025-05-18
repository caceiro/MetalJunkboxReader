import SwiftUI

struct BrandLabel: View {
    let text: String
    let font: Font
    let color: Color
    var body: some View {
        Text(text)
            .font(font)
            .foregroundColor(color)
    }
}

struct BrandIcon: View {
    let systemName: String
    let color: Color
    let size: CGFloat
    var body: some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
            .frame(width: size, height: size)
    }
} 