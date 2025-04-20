//
//  PosterResultView.swift
//  Raccon
//
//  Created by Gabrielle Barling on 4/6/25.
//

import SwiftUI

struct PosterResultView: View {
    let posterImage: UIImage
    @Binding var appState: AppState
    @State private var showingShareSheet = false

    var body: some View {
        VStack {
            Text("Your Wanted Poster")
                .font(.title)
                .padding()

            Image(uiImage: posterImage)
                .resizable()
                .scaledToFit()
                .padding()

            Button("Create Another") {
                appState = .takePhoto
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button("Save Photo") {
                UIImageWriteToSavedPhotosAlbum(posterImage, nil, nil, nil)
                print("Saved poster image to photo library")
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button("Share Photo") {
                showingShareSheet = true
            }
            .buttonStyle(.borderedProminent)
            .padding()
            .sheet(isPresented: $showingShareSheet) {
                ActivityViewController(activityItems: [posterImage])
            }
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
