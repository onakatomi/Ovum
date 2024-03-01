//
//  ChatHomeContent.swift
//  Ovum
//
//  Created by Ollie Quarm on 29/2/2024.
//

import SwiftUI

struct ChatHomeContent: View {
    func viewChatHistory() { print("hey") }
    @State private var textInput = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Image("ovum_purple")
                .padding([.top], 86)
            Text("How can we help today?")
                .font(.title)
                .foregroundColor(Color(red: 0.49, green: 0.27, blue: 0.18))
                .padding([.bottom], 107)
                .padding([.top], 16)
            Button(action: viewChatHistory) {
                Text("View Chat History")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color(red: 0.49, green: 0.27, blue: 0.18))
            }
            .padding()
            .background(
              RoundedRectangle(cornerRadius: 6)
                .inset(by: 0.5)
                .stroke(Color(red: 0.49, green: 0.27, blue: 0.18), lineWidth: 1)
            )
            .padding([.bottom], 20)
            Divider()
            VStack {
                NavigationLink(destination: ChatDetail()) {
                    MessageInputField(textInput: $textInput, handler: doIt)
                        .padding([.top], 15)
                    .padding([.bottom], 15)
                }
            }
            Divider()
        }
            .padding([.horizontal], 20)
    }
}

func doIt() {
    print("do nothing")
}

#Preview {
    ChatHomeContent()
}
