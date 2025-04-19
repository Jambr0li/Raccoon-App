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
        }
    }
}
