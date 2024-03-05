import SwiftUI

struct ChatSessionTile: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var date: String
    var colour: Color
}
