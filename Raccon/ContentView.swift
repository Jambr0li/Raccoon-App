import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var image: UIImage?
    @State private var showCamera = false
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding()
                
                Button("Take Another Photo") {
                    requestCameraAccess()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
//                Probably put openai call in here
            } else {
                Image(systemName: "camera.fill")
                    .imageScale(.large)
                    .font(.system(size: 50))
                    .foregroundStyle(.tint)
                    .padding()
                
                Button("Take Photo") {
                    requestCameraAccess()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $image, showCamera: $showCamera)
        }
    }
    
    // Explicitly request camera access before showing picker
    private func requestCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.showCamera = true
                    } else {
                        print("Camera access denied by user")
                    }
                }
            }
        case .denied, .restricted:
            print("Camera access denied or restricted")
            // Optionally, guide user to Settings
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        @unknown default:
            print("Unknown camera authorization status")
        }
    }
}

#Preview {
    ContentView()
}
