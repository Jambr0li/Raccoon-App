import SwiftUI
import AVFoundation

enum AppState {
    case takePhoto
    case generatingPoster(image: UIImage)
    case posterReady(poster: UIImage)
}

struct ContentView: View {
    @State private var appState: AppState = .takePhoto
    
    var body: some View {
        switch appState {
        case .takePhoto:
            PhotoCaptureView(appState: $appState)
        case .generatingPoster(let image):
            PosterGeneratingView(raccoonImage: image, appState: $appState)
        case .posterReady(let poster):
            PosterResultView(posterImage: poster, appState: $appState)
        }
    }
}

#Preview {
    ContentView()
}
