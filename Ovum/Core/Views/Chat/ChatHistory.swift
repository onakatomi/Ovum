import SwiftUI

struct ChatHistory: View {
    @Environment(MessageViewModel.self) var viewModel
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                    print("Action")
                    dismiss()
                } label: {
                    Image("back_button")
                }
                Spacer()
                Image("menu_brown")
            }
                .padding(.bottom, 18)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            HStack(alignment: .top) {
                Header(firstLine: "Chat", secondLine: "History", colour: AppColours.maroon)
                Spacer()
                Button {
                    Task {
                        try await viewModel.fetchChatSessions(userId: authViewModel.currentUser!.id)                        
                    }
                } label: {
                    Text("Sessions")
                }
                Spacer()
                Image("chat_history")
                    .resizable()
                    .frame(width: 44.0, height: 44.0)
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
        .padding(.horizontal, 20)
        .background {
            AppColours.brown
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChatHistory()
        .environment(MessageViewModel())
}
