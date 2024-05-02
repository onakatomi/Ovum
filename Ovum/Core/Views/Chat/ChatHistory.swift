import SwiftUI

struct ChatHistory: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var router: Router
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var filteredSessions: [ChatSession] {
        let orderedChatSessions: [ChatSession] = viewModel.chatSessions.sorted(by: {
                convertToDate(dateString: $0.date)!.compare(convertToDate(dateString: $1.date)!) == .orderedDescending
            })
        
        if (searchText == "") {
            return orderedChatSessions
        } else {
            return orderedChatSessions.filter { chatSession in
                chatSession.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    router.navigateToRoot(within: .chat)
                } label: {
                    Image("back_button")
                }
                Spacer()
            }
                .padding(.bottom, 18)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            HStack(alignment: .top) {
                Header(firstLine: "Chat", secondLine: "History", colour: AppColours.maroon, font: .custom(AppFonts.testDomaine, size: 42), bolded: false)
                Spacer()
                Button {
                    router.navigateToRoot(within: .chat)
                    router.navigateWithinChat(to: .chatDetail)
                } label: {
                    Image("add_button")
                        .resizable()
                        .frame(width: 33.0, height: 33.0)
                }
            }
                .padding(.bottom, 16)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            HStack(spacing: 14) {
                    Image("search")
                        .resizable()
                        .frame(width: 18.0, height: 18.0)
                    TextField("Search history", text: $searchText)
                }
                .padding(EdgeInsets(top: 22, leading: 18, bottom: 22, trailing: 18))
                .background(Color(.white))
                .cornerRadius(6)
                .padding(.bottom, 40)
            if filteredSessions.count == 0 {
                Text("*No recorded chat logs; go ahead and have your first now!*")
                    .font(.caption)
                    .foregroundColor(AppColours.maroon)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredSessions) { chatSession in
                        NavigationLink(value: ChatNavDestination.chatHistoryDetail(session: chatSession)) {
                            ChatTile(chatTile: chatSession)
                        }
                    }
                    .animation(.default, value: filteredSessions)
                }
            }
        }
        .uxcamTagScreenName("ChatHistory")
        .padding(.horizontal, 20)
        .background {
            AppColours.brown
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    ChatHistory()
//        .environmentObject(MessageViewModel(userId: "1"))
//}
