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
                            Label("Overview", systemImage: "allergens")
                        }
//                            .toolbarBackground(
//                                Color.yellow,
//                                for: .tabBar)
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
                .toolbarBackground(Color(Color(red: 0.98, green: 0.96, blue: 0.92)), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)

//                .toolbarColorScheme(.dark, for: .tabBar)
            }
//                .ignoresSafeArea()
        }
//        .ignoresSafeArea()
        
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
