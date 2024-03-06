import SwiftUI

struct ChatSession: Identifiable, Hashable {
    var id = UUID()
    var messages: [Message]
    var title: String
    var date: String
    var colour: Color
}
