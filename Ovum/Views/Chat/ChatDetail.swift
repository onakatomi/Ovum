import SwiftUI

struct ChatDetail: View {
    @Environment(MessageViewModel.self) var viewModel
    @State private var inputText: String = ""
    @State private var awaitingResponse: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Image("menu_brown")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 8)
                    .padding(.bottom, 18)
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
                            ForEach(viewModel.messages) { message in
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
                        .onChange(of: viewModel.messages.count) {
                            withAnimation {
                                scrollViewProxy.scrollTo(viewModel.messages[viewModel.messages.count - 1].id, anchor: .top)
                            }
                        }
                        .onAppear {
                            if (!viewModel.messages.isEmpty) {
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
                awaitingResponse = true
                let textCopy: String = inputText
                self.inputText = ""
                await viewModel.addMessage(message: Message(author: "John", fromOvum: false, content: textCopy))
                await viewModel.postRequest(message: textCopy)
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
