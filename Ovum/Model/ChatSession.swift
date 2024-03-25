import SwiftUI

struct ChatSession: Identifiable, Hashable {
    var id = UUID().uuidString
    var messages: [Message]
    var bodyParts: [BodyPart]
    var symptoms: [String]
    var title: String
    var date: String
    var colour: Color
    var summary: String?
}
