//
//  ChatBubble.swift
//  Ovum
//
//  Created by Ollie Quarm on 1/3/2024.
//

import SwiftUI

struct ChatBubble: View {
    let content: String
    let author: String
    
    var body: some View {
        VStack(alignment: author == "Ovum" ? .leading : .trailing, spacing: 5) {
            Text(author)
                .font(.caption)
                .foregroundColor(.gray)
            Text(content)
                .padding(16)
                .background(author == "Ovum" ? Color(.white) : Color(red: 0.86, green: 0.84, blue: 0.98))
                .cornerRadius(6)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: author == "Ovum" ? .leading : .trailing)
    }
}

#Preview {
    ChatBubble(content: "My period was a few days late, and when i got it, I was bleeding for 8 days straight, and then now 5 days later I'm bleeding again. What's going on?", author: "John")
}
