import Foundation

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    let baseUrl = "http://127.0.0.1:5000"
    let endpoint = "/get_next_message"
    
    init() {
        addMessages()
    }
    
    func addMessages() {
        messages = chatData
    }
    
    func addMessage(message: Message) async {
        print("hey \(message.content)")
        messages.append(message)
    }
    
    func reverseList() {
        messages.reverse()
    }
    
    func postRequest(message: String) async {
        let dataToSend: [String: Any] = [
            "user_id": "1",
            "user_name": "Sarah",
            "message": message
        ]
        print("pls")
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
                await addMessage(message: Message(author: "Ovum", fromOvum: true, content: product.response))
            } catch {
                print("POST Request Failed:", error)
            }
        }
    }
}

struct Response: Codable {
    var response: String
}

let chatData: [Message] = [
//    Message(author: "John", fromOvum: false, content: "Hey"),
//    Message(author: "John", fromOvum: false, content: "Are you there?"),
//    Message(author: "Ovum", fromOvum: true, content: "Hey"),
//    Message(author: "John", fromOvum: false, content: "How r u"),
//    Message(author: "Ovum", fromOvum: true, content: "Bye!"),
//    Message(author: "John", fromOvum: false, content: "Don't gooooo"),
]
