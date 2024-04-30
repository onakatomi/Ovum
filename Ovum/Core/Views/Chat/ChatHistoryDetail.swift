import SwiftUI

struct ChatHistoryDetail: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    let chatSession: ChatSession
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("back_button")
                }
                Spacer()
//                NavigationLink (destination: Menu().toolbar(.hidden, for: .tabBar)) { // Hide tabbar whilst in MenuScreen.
//                    Image("menu_brown")
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                        .padding(.trailing, 8)
//                        .padding(.bottom, 18)
//                }
            }
            .padding(.bottom, 18)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(chatSession.title)
                        .font(Font.title3.weight(.bold))
                        .foregroundColor(AppColours.maroon)
                    Text(stripDateString(dateString: chatSession.date, format: .elegant))
                        .font(Font.headline.weight(.thin))
                }
                Spacer()
            }
                .padding(.bottom, 40)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(chatSession.messages) { message in
                        ChatBubble(content: message.content, author: message.author == "Ovum" ? "Ovum" : authViewModel.currentUser!.name, disableAnimation: true)
                    }
                    Rectangle()
                        .fill(AppColours.brown)
                        .frame(height: 1)
                        .id("bottomRect")
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

//#Preview {
//    ChatHistory()
//        .environmentObject(MessageViewModel(userId: "1"))
//}
