import Foundation

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    
    
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
}

let chatData = [
    Message(author: "John", fromOvum: false, content: "Hey"),
    Message(author: "John", fromOvum: false, content: "Are you there?"),
    Message(author: "Ovum", fromOvum: true, content: "Hey"),
    Message(author: "John", fromOvum: false, content: "How r u"),
    Message(author: "Ovum", fromOvum: true, content: "Bye!"),
    Message(author: "John", fromOvum: false, content: "Don't gooooo"),
]
