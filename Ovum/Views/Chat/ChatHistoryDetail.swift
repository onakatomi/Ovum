import SwiftUI

struct ChatHistoryDetail: View {
    let chatSession: ChatSession
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
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
                VStack(alignment: .leading) {
                    Text(chatSession.title)
                        .font(Font.title3.weight(.bold))
                        .foregroundColor(AppColours.maroon)
                    Text(chatSession.date)
                        .font(Font.headline.weight(.thin))
                }
                Spacer()
                Image("edit")
                    .resizable()
                    .frame(width: 28.0, height: 28.0)
            }
                .padding(.bottom, 40)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(chatSession.messages) { message in
                        ChatBubble(content: message.content, author: message.author)
                    }
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
