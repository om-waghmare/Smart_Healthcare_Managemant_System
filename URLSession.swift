//
//  URLSession.swift
//  hms-structured
//
//  Created by Om Waghmare on 26/01/25.
//

import Foundation

class OpenAIChatbot {
    private let apiKey = "YOUR_OPENAI_API_KEY"
    private let endpoint = "https://api.openai.com/v1/chat/completions"

    func sendMessage(message: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: endpoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo", // or "gpt-4"
            "messages": [
                ["role": "user", "content": message]
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error encoding request body: \(error)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error decoding response: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
