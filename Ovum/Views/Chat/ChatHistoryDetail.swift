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
                .background(Color(red: 0.4, green: 0.16, blue: 0.06))
                .padding(.bottom, 16)
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(chatSession.title)
                        .font(Font.title3.weight(.bold))
                        .foregroundColor(Color(red: 0.4, green: 0.16, blue: 0.06))
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
                .background(Color(red: 0.4, green: 0.16, blue: 0.06))
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
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChatHistory()
        .environment(MessageViewModel())
}
