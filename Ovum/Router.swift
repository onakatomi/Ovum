import Foundation
import SwiftUI

enum ContentViewTab {
    case overview
    case chat
    case records
}

enum ChatNavDestination: Hashable {
    case chatDetail
    case chatHistory
    case chatHistoryDetail(session: ChatSession)
}

enum RecordsNavDestination: Hashable {
    case documentDetail(document: Document)
    case chatOnDocument(document: Document)
}

enum OverviewNavDestination {
    case unsure
}

class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case menu
    }
    
    @Published var selectedTab: ContentViewTab = .overview
    @Published var overviewNavigation: [OverviewNavDestination] = []
    @Published var chatNavigation: [ChatNavDestination] = []
    @Published var recordsNavigation: [RecordsNavDestination] = []
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        print("Navigating...")
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
