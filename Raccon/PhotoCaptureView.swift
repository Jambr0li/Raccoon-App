//
//  PhotoCaptureView.swift
//  Raccon
//
//  Created by Gabrielle Barling on 4/6/25.
//

import SwiftUI
import AVFoundation
import Photos

struct PhotoCaptureView: View {
    @Binding var appState: AppState
    @State private var image: UIImage?
    @State private var showCamera = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding()
                
                Button("Generate Wanted Poster") {
                    appState = .generatingPoster(image: image)
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("Take Another Photo") {
                    sourceType = .camera
                    requestCameraAccess()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("Select Photo from Library") {
                    sourceType = .photoLibrary
                    requestPhotoLibraryAccess()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            } else {
                Image(systemName: "camera.fill")
                    .imageScale(.large)
                    .font(.system(size: 50))
                    .foregroundStyle(.tint)
                    .padding()
                
                Button("Take Photo") {
                    sourceType = .camera
                    requestCameraAccess()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                Button("Select Photo from Library") {
                    sourceType = .photoLibrary
                    requestPhotoLibraryAccess()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .sheet(isPresented: $showCamera) {
            CameraView(image: $image, showCamera: $showCamera, sourceType: $sourceType)
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
    
    // Explicitly request photo library access before showing picker
    private func requestPhotoLibraryAccess() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized, .limited:
            showCamera = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized || status == .limited {
                        self.showCamera = true
                    } else {
                        print("Photo library access denied by user")
                    }
                }
            }
        case .denied, .restricted:
            print("Photo library access denied or restricted")
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        @unknown default:
            print("Unknown photo library authorization status")
        }
    }
}
