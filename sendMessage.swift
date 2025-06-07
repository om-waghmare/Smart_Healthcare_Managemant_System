//
//  sendMessage.swift
//  hms-structured
//
//  Created by Om Waghmare on 26/01/25.
//

let chatbot = OpenAIChatbot()
chatbot.sendMessage(message: "Hello, how are you?") { response in
    if let response = response {
        print("Chatbot: \(response)")
    } else {
        print("Failed to get a response from the chatbot.")
    }
}
