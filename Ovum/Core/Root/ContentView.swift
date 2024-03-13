import SwiftUI

struct ContentView: View {
    //    @Environment(Router.self) var router
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var router = Router()
    
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
                                            
                                        case .chatOnDocument(let document):
                                            ChatDetail(document: document.file)
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

                // Make sure the new value is persisted.
                router.selectedTab = selectedTab
            }
        )
    }
}

#Preview {
    ContentView(router: Router())
    //        .environment(Router())
        .environment(MessageViewModel())
//        .environment(AuthViewModel())
}
