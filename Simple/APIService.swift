//
//  APIService.swift
//  Simple
//
//  Created by Himanshu vyas on 28/08/25.
//

import Foundation
import UIKit

class APIService {
    static let shared = APIService()
    private init() {}
    
    private let apiKey = "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"
    private let url = URL(string: "https://openrouter.ai/api/v1/chat/completions")!
    
    func sendMessage(_ text: String) async throws -> [Message] {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "google/gemini-2.5-flash-image-preview:free",
            "messages": [
                ["role": "user", "content": text]
            ]
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
        
        guard let message = decoded.choices.first?.message else {
            throw NSError(domain: "API", code: -1, userInfo: [NSLocalizedDescriptionKey: "No message in response"])
        }
        
        var results: [Message] = []
        
        // ✅ Add text if available
        if let content = message.content, !content.isEmpty {
            results.append(Message(isUser: false, type: .text(content)))
        }
        
        // ✅ Add images if available
        if let images = message.images {
            for img in images {
                if let image = decodeBase64Image(from: img.image_url.url) {
                    results.append(Message(isUser: false, type: .image(image)))
                }
            }
        }
        return results
    }
    
    // 🔑 Decode Base64 safely
    private func decodeBase64Image(from base64Url: String) -> UIImage? {
        guard let range = base64Url.range(of: "base64,") else { return nil }
        let base64String = String(base64Url[range.upperBound...])
        guard let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else { return nil }
        return UIImage(data: data)
    }
}
