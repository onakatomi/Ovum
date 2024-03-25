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
    @State var sessionJustFinished: Bool = false
    @State var isExitAttempted = false
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Rectangle()
            ZStack(alignment: .top) {
                Image("chat")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 10, opaque: true)
                VStack(spacing: 10) {
                    HStack {
                        Button {
                            Task {
                                isExitAttempted = true
                            }
                        } label: {
                            Image("back_button_white")
                        }
                        Spacer()
                    }
                    Divider()
                        .background(Color(.white))
                    HStack(alignment: .top) {
                        Header(firstLine: "Chat with", secondLine: "Ovum", colour: Color(.white))
                        Spacer()
                    }
                }
                .padding([.top], 60)
                .padding([.horizontal], 20)
                
            }
            
            // Chat component (looks like it's in a tray)
            ZStack {
                VStack(spacing: 0) {
                    if !sessionJustFinished {
                        VStack {
                            VStack(spacing: 0) {
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
                                        withAnimation {
                                            scrollViewProxy.scrollTo("bottomRect", anchor: .bottom)
                                        }
                                    }
                                }
                            }
                            
                            HStack {
                                Text("Finished logging your symptom?")
                                    .font(.subheadline)
                                Button {
                                    Task {
                                        viewModel.isLoading = true
                                        await viewModel.summariseConversation(authorId: authViewModel.currentUser!.id, authorName: authViewModel.currentUser!.name)
                                        viewModel.endSession()
                                        //                            let summary: String = viewModel.currentSession.summary ?? ""
                                        viewModel.isLoading = false
                                        sessionJustFinished = true
                                        isNewSession = true
                                    }
                                } label: {
                                    Text("Save to Ovum")
                                        .font(.subheadline)
                                        .padding(10)
                                        .background(AppColours.green)
                                        .cornerRadius(6)
                                }
                            }
                            .padding(.vertical, 20)
                        }
                        .padding([.horizontal], 20)
                    }
                    
                    if sessionJustFinished {
                        VStack(alignment: .center, spacing: 10) {
                            Spacer()
                            Text("**Chat Summary:** \(viewModel.chatSessions.last?.summary ?? "No summary")")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                            Image("chat_completed")
                                .padding()
                            Text("Thank you. Do you have something else to discuss?")
                                .font(.body)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .padding(.all, 30)
                    }
                    Divider()
                        .background(AppColours.maroon)
                    SendMessageField(textInput: $inputText, isDisabled: awaitingResponse) {
                        //                            print(authViewModel.currentUser?.email)
                        //                            print(authViewModel.currentUser?.id)
                        if (sessionJustFinished == true) {
                            sessionJustFinished = false
                        }
                        
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
                .padding([.top], 15)
                .background {
                    AppColours.brown
                        .ignoresSafeArea(.all, edges: Edge.Set(Edge.top))
                }
                .navigationBarBackButtonHidden(true)
                //                .opacity(viewModel.isLoading ? 0.5 : 1.0)
                if (viewModel.isLoading) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColours.maroon))
                }
            }
            .clipShape(
                .rect(
                    topLeadingRadius: 12,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 12
                )
            )
            .padding([.top], 220)
            .alert("Exit chat session via top left arrow", isPresented: $router.attemptAtExitUnresolved) {
                Button("Okay", role: .cancel) {
                    router.exitOutcome = .leave
                    router.attemptAtExitUnresolved = false
                    //                Button("No, let's continue chatting", role: .cancel) {
                    //                    router.exitOutcome = .stay
                    //                    router.attemptAtExitUnresolved = false
                    //                }
                }
            }
            .alert("Are you sure you want to exit without logging this symptom?", isPresented: $isExitAttempted) {
                VStack {
                    Button("Exit without saving", role: .destructive) {
                        
                        viewModel.endSession(save: false)
                        dismiss()
                    }
                    Button("No, let's continue chatting", role: .cancel) {
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: Edge.Set(Edge.top))
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
        .environmentObject(AuthViewModel())
        .environmentObject(Router())
}
