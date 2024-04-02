import Foundation
import SwiftUI

struct Document: Codable, Identifiable, Hashable {
    var id = UUID()
    let title: String
    let date: String
    let type: DocumentType
    var file: String // b64 encoded string
    let summary: String
}
