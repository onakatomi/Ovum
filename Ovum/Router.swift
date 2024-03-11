import Foundation
import SwiftUI

@Observable
class Router {
    var navPath = NavigationPath()
    
    public enum Destination: Codable, Hashable {
        case livingroom
        case bedroom(owner: String)
    }
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
