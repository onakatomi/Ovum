import SwiftUI

struct ContentView: View {
    //    @Environment(Router.self) var router
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else {
                ZStack {
                    Color.red
                    TabView(selection: createTabViewBinding()) {
                        Group {
                            NavigationStack(path: $router.overviewNavigation) {
                                BaseView(BaseViewType.overview)
                            }
                            .tabItem {
                                Image(router.selectedTab == .overview ? "tab_overview_active" : "tab_overview_inactive")
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
                                            ChatDetail()
                                            
                                        case .chatHistoryDetail(let session):
                                            ChatHistoryDetail(chatSession: session)
                                            
                                        case .chatOnDocument(let document):
                                            ChatDetail(document: document.file)             
                                        
                                        case .chatComplete(let session):
                                            ChatCompleted(chatSession: session)
                                        }
                                    }
                            }
                            .tabItem {
                                Image(router.selectedTab == .chat ? "tab_chat_active" : "tab_chat_inactive")
                                Text("Chat")
                            }
                            .tag(ContentViewTab.chat)
                            NavigationStack(path: $router.recordsNavigation) {
                                BaseView(BaseViewType.documents)
                                    .navigationDestination(for: RecordsNavDestination.self) { destination in
                                        switch destination {
                                        case .documentDetail(let document):
                                            RecordDetail(document: document)
                                        }
                                    }
                            }
                            .tabItem {
                                Image(router.selectedTab == .records ? "tab_records_active" : "tab_records_inactive")
                                Text("Records")
                            }
                            .tag(ContentViewTab.records)
                        }
                        .toolbarBackground(Color(AppColours.brown), for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    }
                    .environmentObject(router)
                    .accentColor(Color(red: 0.3, green: 0.1, blue: 0.04))
                }
            }
        }
    }
    
    private func createTabViewBinding() -> Binding<ContentViewTab> {
        Binding<ContentViewTab>(
            get: { router.selectedTab },
            set: { selectedTab in
                
                if router.selectedTab == ContentViewTab.chat && (router.chatNavigation.last == Ovum.ChatNavDestination.chatDetail  || (router.chatNavigation.count > 0 && router.chatNavigation.last != Ovum.ChatNavDestination.chatHistory)) {
                    print("trying to leave chat")
                    router.attemptAtExitUnresolved = true
//                    router.attemptAtExitUnresolved = true
//                    router.exitOutcome = .unresolved
//                    while router.exitOutcome == .unresolved {
//                        
////                        print("while ")
//                    }
//                    print("while oassed")
//                    if router.exitOutcome == .stay {
                        withAnimation {
                            router.chatNavigation = router.chatNavigation
                        }
                        return
//                    }
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
    ContentView()
    //        .environment(Router())
        .environment(MessageViewModel())
    //        .environment(AuthViewModel())
}
