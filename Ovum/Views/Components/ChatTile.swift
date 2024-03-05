import SwiftUI

struct ChatTile: View {
    let chatTile: ChatSessionTile
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(red: 0.4, green: 0.16, blue: 0.06))
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
                .foregroundStyle(Color(red: 0.4, green: 0.16, blue: 0.06))
                Spacer()
                Image(systemName: "arrow.right")
            }
            .padding(.bottom, 24)
        }
    }
}

#Preview {
        ChatTile(chatTile: ChatSessionTile(title: "Irregular bleeding patterns", date: "17/2/22", colour: Color(red: 0.95, green: 0.82, blue: 0.83)))
}
