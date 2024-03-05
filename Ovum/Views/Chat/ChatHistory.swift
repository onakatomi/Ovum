import SwiftUI

struct ChatHistory: View {
    @State private var searchText: String = ""
    @ObservedObject var viewModel = MessageViewModel()
    
    var filteredSessions: [ChatSessionTile] {
        if (searchText == "") {
            viewModel.chatSessions
        } else {
            viewModel.chatSessions.filter { chatSession in
                chatSession.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
//    print(filteredSessions)
    
    var body: some View {
        VStack(spacing: 0) {
                Image(systemName: "filemenu.and.cursorarrow")
                    .imageScale(.large)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.black)
                Divider()
                    .background(Color(red: 0.4, green: 0.16, blue: 0.06))
                    .padding(.bottom, 16)
                HStack(alignment: .top) {
                    Header(firstLine: "Chat", secondLine: "History", colour: Color(red: 0.4, green: 0.16, blue: 0.06))
                    Spacer()
                    Image("chat_history")
                        .resizable()
                        .frame(width: 44.0, height: 44.0)
                }
                    .padding(.bottom, 16)
                Divider()
                    .background(Color(red: 0.4, green: 0.16, blue: 0.06))
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
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredSessions) { chatSession in
                        NavigationLink {
                            ChatHomeContent()
                        } label: {
                            ChatTile(chatTile: chatSession)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .background {
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ChatHistory()
}
