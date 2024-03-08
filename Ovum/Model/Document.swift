import Foundation
import SwiftUI

struct Document: Identifiable, Hashable {
    var id = UUID()
    let title: String
    let date: String
    let type: RecordType
    let file: String // b64 encoded string
}
