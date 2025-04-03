import SwiftUI
import AVFoundation
import Photos

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var showCamera: Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        // Check camera availability explicitly
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available on this device")
            DispatchQueue.main.async {
                self.showCamera = false // Dismiss sheet on main thread
            }
            return picker
        }
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                // Request photo library authorization and save
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                    DispatchQueue.main.async {
                        if status == .authorized {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            print("Photo saved to library")
                        } else {
                            print("Photo library access denied")
                        }
                        self.parent.showCamera = false // Dismiss on main thread
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.parent.showCamera = false // Dismiss if no image
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            DispatchQueue.main.async {
                self.parent.showCamera = false // Dismiss on main thread
            }
        }
    }
}
