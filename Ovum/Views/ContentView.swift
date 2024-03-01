import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                BaseView(BaseViewType.overview)
                    .tabItem {
                        Label("Overview", systemImage: "allergens")
                    }
                    .tag(0)
                BaseView(BaseViewType.chat)
                    .tabItem {
                        Label("Chat", systemImage: "bubble.right")
                    }
                    .tag(1)
                BaseView(BaseViewType.documents)
                    .tabItem {
                        Label("Records", systemImage: "doc.fill")
                    }
                    .tag(2)
            }
        }
        .ignoresSafeArea()
//        .toolbarBackground(.visible, for: .tabBar)
//        .tabViewStyle(DefaultTabViewStyle())
        
//            .onChange(of: selectedTab) {
//                    print(selectedTab)
//                }
        }
    }

#Preview {
    ContentView()
}
