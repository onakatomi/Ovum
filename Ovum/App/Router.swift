import Foundation
import SwiftUI

enum ContentViewTab {
    case overview
    case chat
    case medication
    case records
}

enum OverviewNavDestination {
    case menu
}

enum ChatNavDestination: Hashable {
    case chatDetail
    case chatHistory
    case chatHistoryDetail(session: ChatSession)
    case chatOnDocument(document: Document)
    case chatComplete(session: ChatSession)
    case menu
}

enum MedicationNavDestination: Hashable {
    case medicationFrequency
    case medicationHistory
    case ongoing
    case shortTerm
    case noLongerTaking    
    case ongoingEdit(medication: Medication)
    case shortTermEdit(medication: Medication)
    case noLongerTakingEdit(medication: Medication)
    case menu
}

enum RecordsNavDestination: Hashable {
    case documentDetail(document: Document)
    case menu
}

enum ResolveOption {
    case unresolved
    case stay
    case leave
}

class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case menu
    }
    
    @Published var selectedTab: ContentViewTab = .chat
    @Published var overviewNavigation: [OverviewNavDestination] = []
    @Published var chatNavigation: [ChatNavDestination] = []
    @Published var medicationNavigation: [MedicationNavDestination] = []
    @Published var recordsNavigation: [RecordsNavDestination] = []
    
    @Published var tabViewsDisabled: Bool = false
    @Published var attemptAtExitUnresolved: Bool = false
    @Published var exitOutcome: ResolveOption = ResolveOption.stay
    
    func navigateWithinOveview(to destination: OverviewNavDestination) {
        selectedTab = .overview
        overviewNavigation.append(destination)
    }
    
    func navigateWithinChat(to destination: ChatNavDestination) {
        selectedTab = .chat
        chatNavigation.append(destination)
    }
    
    func navigateWithinMedication(to destination: MedicationNavDestination) {
        selectedTab = .medication
        medicationNavigation.append(destination)
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
                
            case .medication:
                medicationNavigation.removeLast()
                
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
                
            case .medication:
                medicationNavigation.removeLast(medicationNavigation.count)
                
            case .records:
                recordsNavigation.removeLast(recordsNavigation.count)
        }
    }
}
