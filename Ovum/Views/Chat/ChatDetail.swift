import SwiftUI

struct ChatDetail: View {
    @Environment(MessageViewModel.self) var viewModel
    @State private var inputText: String = ""
    @State private var awaitingResponse: Bool = false
    @State private var currentSession: ChatSession = ChatSession(messages: [], title: "Chat Session", date: DateFormatter().string(from: Date.now), colour: Color(red: 0.95, green: 0.82, blue: 0.83))
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
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
                Divider()
                    .background(Color(red: 0.4, green: 0.16, blue: 0.06))
                HStack(alignment: .top) {
                    Header(firstLine: "Chat with", secondLine: "Ovum", colour: Color(red: 0.4, green: 0.16, blue: 0.06))
                    Spacer()
                    Image("level_high")
                        .resizable()
                        .frame(width: 49, height: 49)
                }
                Divider()
                    .background(Color(red: 0.4, green: 0.16, blue: 0.06))
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(currentSession.messages) { message in
                                ChatBubble(content: message.content, author: message.author)
                            }
                            if (awaitingResponse) {
                                TypingIndicator()
                                    .frame(width: 80, height: 40, alignment: .leading)
                                    .id("typingIndicator")
                            }
                            Rectangle()
                                .fill(Color(red: 0.98, green: 0.96, blue: 0.92))
                                .frame(height: 1)
                                .id("bottomRect")
                        }
                        .padding([.bottom], 10)
                        .onChange(of: currentSession.messages.count) {
                            withAnimation {
                                scrollViewProxy.scrollTo(viewModel.messages[viewModel.messages.count - 1].id, anchor: .top)
                            }
                        }
                        .onAppear {
                            if (!currentSession.messages.isEmpty) {
                                withAnimation {
                                    scrollViewProxy.scrollTo("bottomRect", anchor: .bottom)
                                }
                                
                            }
                        }
                    }
                }
            }
            .padding([.horizontal], 20)
            Divider()
                .background(Color(red: 0.4, green: 0.16, blue: 0.06))
            SendMessageField(textInput: $inputText) {
                print(currentSession.id)
                awaitingResponse = true
                let textCopy: String = inputText
                self.inputText = ""
                let sentMessage = Message(author: "John", fromOvum: false, content: textCopy)
                currentSession.messages.append(sentMessage)
                
                // Call async functions
                await viewModel.addMessage(message: sentMessage)
                let ovumReply = await viewModel.postRequest(message: textCopy)
                if let ovumReply {
                    currentSession.messages.append(ovumReply)
                }
                viewModel.addSession(session: currentSession)
                awaitingResponse = false
            }
            .padding([.horizontal], 20)
            .padding([.vertical], 15)
        }
        .background {
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea(.all, edges: Edge.Set(Edge.top))
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    ChatDetail()
        .environment(MessageViewModel())
}
