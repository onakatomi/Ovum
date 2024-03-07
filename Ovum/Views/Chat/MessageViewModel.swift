import Foundation
import SwiftUI

@Observable
class MessageViewModel {
    var messages: [Message] = []
    var chatSessions: [ChatSession] = []
    var documents: [Document] = []
    
    let baseUrl = "http://127.0.0.1:5000"
    let endpoint = "/get_next_message"
    
    init() {
        messages = []
        chatSessions = []
        documents = documentsMock
    }
    
    func addMessage(message: Message) async {
        print("---> \(message.content)")
        messages.append(message)
    }
    
    func createSession() {
        
    }
    
    func addSession(session: ChatSession) {
        let indexOfSession: Int? = chatSessions.firstIndex(where: {$0.id == session.id})
        if let indexOfSession {
            chatSessions[indexOfSession] = session // Update session with updated messages array.
        } else {
            // Else session doesn't exist yet.
            chatSessions.append(session)
        }
    }
    
    func postRequest(message: String) async -> Message? {
        let dataToSend: [String: Any] = [
            "user_id": "1",
            "user_name": "Sarah",
            "message": message
        ]
        if let url = URL(string: baseUrl + endpoint) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dataToSend)
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                let product = try decoder.decode(Response.self, from: data)
                print(product.response)
                let responseMessage: Message = Message(author: "Ovum", fromOvum: true, content: product.response)
                await addMessage(message: responseMessage)
                return responseMessage
            } catch {
                print("POST Request Failed:", error)
            }
        }
        return nil
    }
}

struct Response: Codable {
    var response: String
}

let chatData: [Message] = [
    Message(author: "John", fromOvum: false, content: "Hey"),
    Message(author: "John", fromOvum: false, content: "Are you there?"),
    Message(author: "Ovum", fromOvum: true, content: "Hey"),
    Message(author: "John", fromOvum: false, content: "How r u"),
    Message(author: "Ovum", fromOvum: true, content: "Bye!"),
    Message(author: "John", fromOvum: false, content: "Don't gooooo"),
]

let chatSessionsMock: [ChatSession] = [
    ChatSession(messages: chatData, title: "Irregular bleeding patterns", date: "17/2/22", colour: Color(red: 0.95, green: 0.82, blue: 0.83)),
    ChatSession(messages: chatData, title: "Regular nausea", date: "17/2/22", colour: Color(red: 0.76, green: 0.73, blue: 0.95)),
    ChatSession(messages: chatData, title: "Concern with knee joints", date: "17/2/22", colour: Color(red: 0.7, green: 0.88, blue: 0.61)),
    ChatSession(messages: chatData, title: "Early period", date: "17/2/22", colour: Color(red: 1, green: 0.82, blue: 0.6)),
    ChatSession(messages: chatData, title: "Explaining your blood results", date: "17/2/22", colour: Color(red: 0.74, green: 0.95, blue: 0.92)),
    ChatSession(messages: chatData, title: "Irregular bleeding patterns", date: "17/2/22", colour: Color(red: 0.95, green: 0.82, blue: 0.83)),
    ChatSession(messages: chatData, title: "Irregular bleeding patterns", date: "17/2/22", colour: Color(red: 0.95, green: 0.82, blue: 0.83)),
]

let documentsMock: [Document] = [
    Document(title: "Hormones", date: "17/2/22", type: RecordType.pathology),
    Document(title: "Referral", date: "17/2/22", type: RecordType.letters),
]
