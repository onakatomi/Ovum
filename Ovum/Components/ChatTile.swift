import SwiftUI

struct ChatTile: View {
    let chatTile: ChatSession
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 24)
            HStack {
                ZStack {
                    Circle()
                        .fill(chatTile.colour)
                        .frame(width: 40, height: 40)
                    Image("chat_bubble")
                        .resizable()
                        .frame(width: 22, height: 22)
                }
                Spacer()
                    .frame(width: 24)
                VStack(alignment: .leading) {
                    Text(chatTile.title)
                        .font(Font.headline.weight(.bold))
                    Text(chatTile.date)
                        .font(Font.headline.weight(.light))
                }
                .foregroundStyle(AppColours.maroon)
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    ChatTile(chatTile: ChatSession(messages: [Message(author: "John", fromOvum: false, content: "Are you there?")], bodyParts: [], title: "Irregular bleeding patterns", date: getDateAsString(date: Date.now), colour: AppColours.pink))
}
