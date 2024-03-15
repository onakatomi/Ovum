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
    case chatOnDocument(document: Document)
}

enum RecordsNavDestination: Hashable {
    case documentDetail(document: Document)
}

enum OverviewNavDestination {
    case unsure
}

class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case menu
    }
    
    @Published var selectedTab: ContentViewTab = .chat
    @Published var overviewNavigation: [OverviewNavDestination] = []
    @Published var chatNavigation: [ChatNavDestination] = []
    @Published var recordsNavigation: [RecordsNavDestination] = []
    @Published var tabViewsDisabled: Bool = false
    
    func navigateWithinOveview(to destination: OverviewNavDestination) {
        selectedTab = .overview
        overviewNavigation.append(destination)
    }
    
    func navigateWithinChat(to destination: ChatNavDestination) {
        selectedTab = .chat
        chatNavigation.append(destination)
    }
    
    func navigateWithinRecords(to destination: RecordsNavDestination) {
        selectedTab = .records
        recordsNavigation.append(destination)
    }
    
    func navigateBack(within tab: ContentViewTab) {
        switch tab {
            case .overview:
                overviewNavigation.removeLast()
                
            case .chat:
                chatNavigation.removeLast()
                
            case .records:
                recordsNavigation.removeLast()
        }
    }
    
    func navigateToRoot(within tab: ContentViewTab) {
        switch tab {
            case .overview:
                overviewNavigation.removeLast(overviewNavigation.count)
                
            case .chat:
                chatNavigation.removeLast(chatNavigation.count)
                
            case .records:
                recordsNavigation.removeLast(recordsNavigation.count)
        }
    }
}
