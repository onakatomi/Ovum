import SwiftUI

struct LoggedInView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @StateObject var viewModel: MessageViewModel
    
    var body: some View {
        Group {
            ZStack {
                Color.red
                TabView(selection: createTabViewBinding()) {
                    Group {
                        NavigationStack(path: $router.overviewNavigation) {
                            BaseView(BaseViewType.overview)
                                .navigationDestination(for: OverviewNavDestination.self) { destination in
                                    switch destination {
                                        case .menu:
                                            Menu().toolbar(.hidden, for: .tabBar)
                                    }
                                }
                        }
                        .tabItem {
                            Image((router.selectedTab == ContentViewTab.chat && router.chatNavigation.last == .chatDetail) ? "tab_overview_disabled" : (router.selectedTab == .overview ? "tab_overview_active" : "tab_overview_inactive"))
                            Text("Overview")
                        }
                        .tag(ContentViewTab.overview)
                        
                        NavigationStack(path: $router.chatNavigation) {
                            BaseView(BaseViewType.chat)
                                .navigationDestination(for: ChatNavDestination.self) { destination in
                                    switch destination {
                                    case .chatHistory:
                                        ChatHistory()
                                        
                                    case .chatDetail:
                                        ChatDetail().toolbar(.hidden, for: .tabBar)
                                        
                                    case .chatHistoryDetail(let session):
                                        ChatHistoryDetail(chatSession: session)
                                        
                                    case .chatOnDocument(let document):
                                        ChatDetail(document: document.file)
                                        
                                    case .chatComplete(let session):
                                        ChatCompleted(chatSession: session)
                                        
                                    case .menu:
                                        Menu().toolbar(.hidden, for: .tabBar)
                                    }
                                }
                        }
                        .tabItem {
                            Image(router.selectedTab == .chat ? "tab_chat_active" : "tab_chat_inactive")
                            Text("Chat")
                        }
                        .tag(ContentViewTab.chat)
                        
                        NavigationStack(path: $router.medicationNavigation) {
                            BaseView(BaseViewType.medication)
                                .navigationDestination(for: MedicationNavDestination.self) { destination in
                                    switch destination {
                                    case .menu:
                                        Menu().toolbar(.hidden, for: .tabBar)
                                    case .medicationFrequency:
                                        MedicationFrequency()
                                    case .medicationHistory:
                                        MedicationHistory()
                                    case .shortTerm:
                                        MedicationFormView(medicationFormType: .shortTerm, medicationObj: nil)
                                    case .ongoing:
                                        MedicationFormView(medicationFormType: .ongoing, medicationObj: nil)
                                    case .noLongerTaking:
                                        MedicationFormView(medicationFormType: .noLongerTaking, medicationObj: nil)
                                    case .ongoingEdit(let medicationObj):
                                        MedicationFormView(medicationFormType: .ongoing, medicationObj: medicationObj)
                                    case .shortTermEdit(let medicationObj):
                                        MedicationFormView(medicationFormType: .shortTerm, medicationObj: medicationObj)
                                    case .noLongerTakingEdit(let medicationObj):
                                        MedicationFormView(medicationFormType: .noLongerTaking, medicationObj: medicationObj)
                                    }
                                }
                        }
                        .tabItem {
                            Image(router.selectedTab == ContentViewTab.medication ? "tab_medication_active" : "tab_medication_inactive")
                            Text("Medication")
                        }
                        .tag(ContentViewTab.medication)
                        
                        NavigationStack(path: $router.recordsNavigation) {
                            BaseView(BaseViewType.documents)
                                .navigationDestination(for: RecordsNavDestination.self) { destination in
                                    switch destination {
                                    case .documentDetail(let document):
                                        RecordDetail(document: document)
                                        
                                    case .menu:
                                        Menu().toolbar(.hidden, for: .tabBar)
                                    }
                                }
                        }
                        .tabItem {
                            Image((router.selectedTab == ContentViewTab.chat && router.chatNavigation.last == .chatDetail) ? "tab_records_disabled" : (router.selectedTab == .records ? "tab_records_active" : "tab_records_inactive"))
                            Text("Records")
                        }
                        .tag(ContentViewTab.records)
                    }
                    .toolbarBackground(Color(AppColours.brown), for: .tabBar)
                    .toolbarBackground(.visible, for: .tabBar)
                }
                .environmentObject(router)
                .accentColor(AppColours.darkBrown)
            }
            .environmentObject(viewModel)
        }
    }
    
    private func createTabViewBinding() -> Binding<ContentViewTab> {
        Binding<ContentViewTab>(
            get: { router.selectedTab },
            set: { selectedTab in
                
                if router.selectedTab == ContentViewTab.chat && (router.chatNavigation.last == Ovum.ChatNavDestination.chatDetail) {
                    print("Preventing action")
                    
                    // Required to keep current state
                    withAnimation {
                        router.chatNavigation = router.chatNavigation
                    }
                    return
                }
                
                // If the option is to leave, proceed with the below.
                if selectedTab == router.selectedTab {
                    print("tapped same tab")
                    
                    switch selectedTab {
                    case .overview:
                        withAnimation {
                            router.overviewNavigation = []
                        }
                        
                    case .chat:
                        withAnimation {
                            router.chatNavigation = []
                        }
                        
                    case .medication:
                        withAnimation {
                            router.medicationNavigation = []
                        }
                        
                    case .records:
                        withAnimation {
                            router.recordsNavigation = []
                        }
                    }
                }
                print("exited")
                
                // Make sure the new value is persisted.
                router.selectedTab = selectedTab
            }
        )
    }
}

#Preview {
    LoggedInView(viewModel: MessageViewModel(userId: "hey", authViewModelPassedIn: AuthViewModel()))
        .environmentObject(AuthViewModel())
        .environmentObject(Router())
}
