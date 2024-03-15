import SwiftUI

struct ChatDetail: View {
    enum FocusedField {
        case inputText
    }
    
    @Environment(MessageViewModel.self) var viewModel
    @EnvironmentObject var router: Router
    @State private var inputText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    @State private var awaitingResponse: Bool = false
    @State private var isNewSession: Bool = true
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var scrollViewHeight: CGFloat = 0
    var document: String?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    HStack {
                        Button {
                            Task {
                                viewModel.isLoading = true
                                await viewModel.summariseConversation()
                                viewModel.endSession()
                                viewModel.isLoading = false
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
                                    ChatBubble(content: message.content, author: message.author == "Ovum" ? "Ovum" : authViewModel.currentUser!.name)
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
                            .background(GeometryReader { geometry in
                                Color.clear
                                    .preference(key: ScrollViewHeightPreferenceKey.self, value: geometry.size.height)
                            })
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
                                if let document {
                                    Task {
                                        print("analysing...")
                                        viewModel.addSession(isNewSession: isNewSession)
                                        awaitingResponse = true
                                        await viewModel.analyseDocument(
                                            document: document,
                                            userId: authViewModel.currentUser!.id
                                        )
                                        awaitingResponse = false
                                        isNewSession = false
                                    }
                                }
                            }
                        }
                        .onPreferenceChange(ScrollViewHeightPreferenceKey.self) { scrollViewHeight = $0
                            print(scrollViewHeight)
                            withAnimation {
                                scrollViewProxy.scrollTo("bottomRect", anchor: .bottom)
                            }
                        }
                    }
                }
                .padding([.horizontal], 20)
                Divider()
                    .background(AppColours.maroon)
                SendMessageField(textInput: $inputText, isDisabled: awaitingResponse) {
                    router.tabViewsDisabled = true
                    viewModel.addSession(isNewSession: isNewSession)
                    print(viewModel.currentSession.id)
                    awaitingResponse = true
                    let textCopy: String = inputText // Make copy so that message passed to API isn't blank.
                    self.inputText = "" // Reset text field.
                    let sentMessage = Message(author: authViewModel.currentUser!.id, fromOvum: false, content: textCopy) // Construct message model.
                    viewModel.addMessage(message: sentMessage) // Add to conversation session.
                    await viewModel.getOvumResponse(message: textCopy, authorId: authViewModel.currentUser!.id, authorName: authViewModel.currentUser!.name) // Get Ovum's response.
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
            .opacity(viewModel.isLoading ? 0.5 : 1.0)
            if (viewModel.isLoading) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColours.maroon))
            }
        }
    }
}

struct ScrollViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

#Preview {
    ChatDetail()
        .environment(MessageViewModel())
}
