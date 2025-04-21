import SwiftUI

struct OrangeButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.orange.opacity(0.7) : Color.orange)
            .foregroundColor(.black)
            .cornerRadius(10)
            .shadow(color: Color.orange.opacity(configuration.isPressed ? 0 : 0.6), radius: 10, x: 0, y: 5)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct OrangeSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 2)
                    .opacity(configuration.isPressed ? 0.7 : 1.0)
            )
            .foregroundColor(Color.orange)
            .background(configuration.isPressed ? Color.orange.opacity(0.2) : Color.clear)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct DarkBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

extension View {
    func darkBackground() -> some View {
        self.modifier(DarkBackground())
    }
}
