import SwiftUI

struct ChatDetail: View {
    enum FocusedField {
        case inputText
    }
    
    @Environment(MessageViewModel.self) var viewModel
    @State private var inputText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    @State private var awaitingResponse: Bool = false
    @State private var isNewSession: Bool = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Button {
                        print("Action")
                        Task {
                            await viewModel.summariseConversation()
                            viewModel.endSession()
                            dismiss()
                        }
                    } label: {
                        Image("back_button")
                    }
                    Spacer()
                    Image("menu_brown")
                }
                Divider()
                    .background(AppColours.maroon)
                HStack(alignment: .top) {
                    Header(firstLine: "Chat with", secondLine: "Ovum", colour: AppColours.maroon)
                    Spacer()
                    Image("level_high")
                        .resizable()
                        .frame(width: 49, height: 49)
                }
                Divider()
                    .background(AppColours.maroon)
                ScrollViewReader { scrollViewProxy in
                    ScrollView(.vertical) {
                        VStack(alignment: .leading, spacing: 15) {
                            ForEach(viewModel.currentSession.messages) { message in
                                ChatBubble(content: message.content, author: message.author)
                            }
                            if (awaitingResponse) {
                                TypingIndicator()
                                    .frame(width: 80, height: 40, alignment: .leading)
                                    .id("typingIndicator")
                            }
                            Rectangle()
                                .fill(AppColours.brown)
                                .frame(height: 1)
                                .id("bottomRect")
                        }
                        .padding([.bottom], 10)
                        .onChange(of: viewModel.currentSession.messages.count) {
                            if (viewModel.currentSession.messages.count != 0) {
                                withAnimation {
                                    scrollViewProxy.scrollTo(viewModel.currentSession.messages[viewModel.currentSession.messages.count - 1].id, anchor: .top)
                                }                                
                            }
                        }
                        .onAppear {
                            if (!viewModel.currentSession.messages.isEmpty) {
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
                .background(AppColours.maroon)
            SendMessageField(textInput: $inputText) {
                viewModel.addSession(isNewSession: isNewSession)
                print(viewModel.currentSession.id)
                awaitingResponse = true
                let textCopy: String = inputText // Make copy so that message passed to API isn't blank.
                self.inputText = "" // Reset text field.
                let sentMessage = Message(author: "John", fromOvum: false, content: textCopy) // Construct message model.
                viewModel.addMessage(message: sentMessage) // Add to conversation session.
                await viewModel.getOvumResponse(message: textCopy) // Get Ovum's response.
                awaitingResponse = false
                isNewSession = false
            }
            .padding([.horizontal], 20)
            .padding([.vertical], 15)
        }
        .background {
            AppColours.brown
                .ignoresSafeArea(.all, edges: Edge.Set(Edge.top))
        }
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    ChatDetail()
        .environment(MessageViewModel())
}
