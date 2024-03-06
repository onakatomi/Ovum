import Foundation

struct Document: Identifiable, Hashable {
    var id = UUID()
    let title: String
    let date: String
    let type: RecordType
}
