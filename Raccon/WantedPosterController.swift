//
//  WantedPosterController.swift
//  Raccon
//
//  Created by Gabrielle Barling on 4/6/25.
//

import Foundation
import UIKit

    
func generatePromptFromImage(image: UIImage, apiKey: String, completion: @escaping (String?) -> Void) {
    // Convert UIImage to base64
    guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
    let base64 = imageData.base64EncodedString()

    let messages: [[String: Any]] = [
        ["role": "user", "content": [
            ["type": "text", "text": "Describe this raccoon image so I can generate a wanted poster of it. Be as descriptive as possible and include any distinguishing features."],
            ["type": "image_url", "image_url": ["url": "data:image/jpeg;base64,\(base64)"]]
        ]]
    ]

    let body: [String: Any] = [
        "model": "gpt-4-turbo",
        "messages": messages
    ]

    var request = URLRequest(url: URL(string: "https://api.openai.com/v1/chat/completions")!)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)

    URLSession.shared.dataTask(with: request) { data, _, _ in
        guard let data = data,
              let response = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = response["choices"] as? [[String: Any]],
              let message = choices.first?["message"] as? [String: Any],
              let content = message["content"] as? String else {
            completion(nil)
            return
        }
        completion(content)
    }.resume()
}

func generateWantedPosterImage(prompt: String, apiKey: String, completion: @escaping (UIImage?) -> Void) {
    let url = URL(string: "https://api.openai.com/v1/images/generations")!

    let payload: [String: Any] = [
        "model": "dall-e-3",
        "prompt": prompt,
        "size": "1024x1024",
        "n": 1
    ]

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

    URLSession.shared.dataTask(with: request) { data, _, error in
        guard error == nil, let data = data else {
            print("Error:", error ?? "Unknown error")
            completion(nil)
            return
        }

        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let dataArr = json["data"] as? [[String: Any]],
           let urlStr = dataArr.first?["url"] as? String,
           let imageURL = URL(string: urlStr) {

            URLSession.shared.dataTask(with: imageURL) { imgData, _, _ in
                if let imgData = imgData, let image = UIImage(data: imgData) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }.resume()
        } else {
            print("Failed to parse DALL·E response")
            completion(nil)
        }
    }.resume()
}

func getWantedPoster(raccoonImage: UIImage, completion: @escaping (UIImage?) -> Void) {
    if let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String {
        generatePromptFromImage(image: raccoonImage, apiKey: apiKey) { description in guard let description else {return}
            
            let posterPrompt = "A wild west wanted poster of a raccoon with the following description: \(description). Style: sepia tone, vintage paper, bold 'WANTED' at the top."
            
            generateWantedPosterImage(prompt: posterPrompt, apiKey: apiKey) { image in DispatchQueue.main.async { completion(image) }}
        }
    } else {
        print("API key not found")
        completion(nil)
    }
}


