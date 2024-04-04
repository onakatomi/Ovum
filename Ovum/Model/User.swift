import Foundation

// Confirming to Codable protocol allows us to take incoming raw JSON data and map it into a Swift object during decoding (like into a User object).
struct User: Identifiable, Codable {
    let id: String
    let email: String
    let name: String
    var dob: String?
    var isPregnant: Bool?
    var lifecycle: String?
    var isOnboardingCompleted: Bool?
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, email: "test@gmail.com", name: "Jane")
}
