import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            Color.blue
            TabView(selection: $selectedTab) {
                Group {
                    BaseView(BaseViewType.overview)
                        .tabItem {
                            Image(selectedTab == 0 ? "tab_overview_active" : "tab_overview_inactive")
                            Text("Overview")
                        }
                        .tag(0)
                    BaseView(BaseViewType.chat)
                        .tabItem {
                            Image(selectedTab == 1 ? "tab_chat_active" : "tab_chat_inactive")
                            Text("Chat")
                        }
                        .tag(1)
                    BaseView(BaseViewType.documents)
                        .tabItem {
                            Image(selectedTab == 2 ? "tab_records_active" : "tab_records_inactive")
                            Text("Records")
                        }
                        .tag(2)
                }
                .toolbarBackground(Color(Color(red: 0.98, green: 0.96, blue: 0.92)), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
            .accentColor(Color(red: 0.3, green: 0.1, blue: 0.04))
        }
        }
    }

#Preview {
    ContentView()
}
