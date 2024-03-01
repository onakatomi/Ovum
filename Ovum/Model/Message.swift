import SwiftUI

struct Message: Identifiable, Hashable {
    var id = UUID()
    var author: String
    var fromOvum: Bool
    var content: String
}
