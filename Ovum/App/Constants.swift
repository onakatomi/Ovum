import SwiftUI
import Foundation

struct AppColours {
    static let brown = Color(red: 0.98, green: 0.96, blue: 0.92)
    static let green = Color(red: 0.7, green: 0.88, blue: 0.61)
    static let indigo = Color(red: 0.76, green: 0.73, blue: 0.95)
    static let maroon = Color(red: 0.4, green: 0.16, blue: 0.06)
    static let mint = Color(red: 0.74, green: 0.95, blue: 0.92)
    static let peach = Color(red: 1, green: 0.82, blue: 0.6)
    static let pink = Color(red: 0.95, green: 0.82, blue: 0.83)
    static let darkBrown = Color(red: 0.3, green: 0.1, blue: 0.04)
    static let darkBeige = Color(red: 0.7, green: 0.45, blue: 0.25)
    static let buttonBrown = Color(red: 0.49, green: 0.27, blue: 0.18)
    static let lightYellow = Color(red: 0.98, green: 0.96, blue: 0.92)
}

struct AppFonts {
    static let haasGrot = "Haas Grot Disp Trial"
    static let testDomaine = "Test Domaine Text"
}

struct Urls {
//    static let baseUrl = "https://ovumendpoints-2b7tck4zpq-uc.a.run.app" // Dev URL
//    static let baseUrl = "https://ovumendpoints-de6mwfd5oa-uc.a.run.app" // Prod URL
//    static let baseUrl = "http://192.168.89.21:5002"
        
    static var baseUrl: String {
        if let baseUrl = Bundle.main.infoDictionary?["API_URL"] as? String {
            print("Using API URL: \(baseUrl)")
            return baseUrl
        }
        print("ERROR: No API URL set.")
        return ""
    }
}

struct AppCheck {
    static var isInternal: Bool {
        if let s = Bundle.main.infoDictionary?["INTERNAL"] as? String {
            return !s.isEmpty
        }
        return false
    }
}

enum MyError: Error {
    case runtimeError(String)
}
