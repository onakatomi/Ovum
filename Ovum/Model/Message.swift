import SwiftUI

struct Message: Identifiable, Codable, Hashable {
    var id = UUID()
    var author: String
    var fromOvum: Bool
    var content: String
}
