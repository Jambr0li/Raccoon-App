//
//  PosterGeneratingView.swift
//  Raccon
//
//  Created by Gabrielle Barling on 4/6/25.
//

import SwiftUI

struct PosterGeneratingView: View {
    let raccoonImage: UIImage
    @Binding var appState: AppState
    @State private var statusText = "Analyzing image..."
    
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView(statusText)
                .progressViewStyle(CircularProgressViewStyle())
                .padding()

            Image(uiImage: raccoonImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)

            Text("Creating your wanted poster...")
                .multilineTextAlignment(.center)
                .padding()
        }
        .onAppear {
            generateWantedPoster()
        }
    }
    
    private func generateWantedPoster() {
        getWantedPoster(raccoonImage: raccoonImage) { posterImage in
            if let posterImage = posterImage {
                appState = .posterReady(poster: posterImage)
            } else {
                statusText = "Failed to generate poster. Try again!"
            }
        }
    }
}
