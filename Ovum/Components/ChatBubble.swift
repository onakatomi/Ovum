import SwiftUI

struct ChatBubble: View {
    let content: String
    let author: String
    var disableAnimation: Bool = false
    @State var caption: String = ""
    
    var body: some View {
        VStack(alignment: author == "Ovum" ? .leading : .trailing, spacing: 5) {
            Text(author)
                .font(.custom(AppFonts.haasGrot, size: 12))
                .foregroundColor(.gray)
            Text(.init(author == "Ovum" && !disableAnimation) ? caption : content)
                .padding(16)
                .background(author == "Ovum" ? Color(.white) : Color(red: 0.86, green: 0.84, blue: 0.98))
                .cornerRadius(6)
                .lineSpacing(5)
                .font(.custom(AppFonts.haasGrot, size: 16))
                .kerning(0.32)
                .onAppear {
                    typeWriter()
                }
        }
        .frame(maxWidth: .infinity, alignment: author == "Ovum" ? .leading : .trailing)
    }
    
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            caption = ""
        }
        if position < content.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.007) {
                caption.append(content[position])
                typeWriter(at: position + 1)
            }
        }
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

#Preview {
    ZStack {
        Color.clear
        VStack {
            ChatBubble(content: "My period was a few days late, and when i got it, I was bleeding for 8 days straight, and then now 5 days later I'm bleeding again. What's going on?", author: "John")
            ChatBubble(content: "My period was a few days late, and when i got it, I was bleeding for 8 days straight, and then now 5 days later I'm bleeding again. What's going on?", author: "Ovum")
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
}
