import SwiftUI

struct ChatSession: Identifiable, Hashable {
    var id = UUID().uuidString
    var messages: [Message]
    var title: String
    var date: String
    var colour: Color
}
