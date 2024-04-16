import Foundation

// Confirming to Codable protocol allows us to take incoming raw JSON data and map it into a Swift object during decoding (like into a User object).
struct OnboardingInfo: Codable {
    let dob: String
    let height: String
    let weight: String
}
