import SwiftUI

struct ChatDetail: View {
    @State private var inputText: String = ""
    @State private var awaitingResponse: Bool = false
    @ObservedObject var viewModel = MessageViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "filemenu.and.cursorarrow")
                    .imageScale(.large)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.black)
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
                        }
                        .onChange(of: viewModel.messages.count) {
                            withAnimation {
                                scrollViewProxy.scrollTo("typingIndicator", anchor: .bottom)
                            }
                        }
                        .onChange(of: awaitingResponse) {
                            if (!viewModel.messages.isEmpty) {
                                withAnimation {
                                    scrollViewProxy.scrollTo(viewModel.messages[viewModel.messages.count - 1].id , anchor: .bottom)
                                }
                            }
                        }
                        .onAppear {
                            if (!viewModel.messages.isEmpty) {
                                withAnimation {
                                    scrollViewProxy.scrollTo(viewModel.messages[viewModel.messages.count - 1].id , anchor: .bottom)
                                }
                                
                            }
                        }
                    }
//                    .frame(maxWidth: .infinity)
                }
            }
            .padding([.horizontal], 20)
            Divider()
                .background(Color(red: 0.4, green: 0.16, blue: 0.06))
                .padding([.vertical], 15)
            MessageInputField(textInput: $inputText) {
                awaitingResponse = true
                await viewModel.addMessage(message: Message(author: "John", fromOvum: false, content: inputText))
                await viewModel.postRequest(message: inputText)
                awaitingResponse = false
            }
                .padding([.horizontal], 20)
        }
        .background {
            Color(red: 0.98, green: 0.96, blue: 0.92)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ChatDetail()
}
