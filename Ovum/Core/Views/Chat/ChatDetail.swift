import SwiftUI

struct ChatDetail: View {
    enum FocusedField {
        case inputText
    }
    
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var healthKitManager: HealthKitManager
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var inputText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    @State private var awaitingResponse: Bool = false
    @State private var isNewSession: Bool = true
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
                        Header(firstLine: "Chat with", secondLine: "Ovum", colour: Color(.white), font: .custom(AppFonts.haasGrot, size: 42))
                        Spacer()
                    }
                }
                .padding([.top], 60)
                .padding([.horizontal], 20)
            }
            
            // Chat component (looks like it's in a tray)
            ZStack {
                VStack(spacing: 0) {
                    VStack {
                        VStack(spacing: 0) {
                            ScrollViewReader { scrollViewProxy in
                                ScrollView(.vertical) {
                                    VStack(alignment: .leading, spacing: 15) {
                                        ChatBubble(content: "Hi \(authViewModel.currentUser!.name). What symptoms are you experiencing at the moment?", author: "Ovum")
                                        ForEach(viewModel.currentSession.messages) { message in
                                            ChatBubble(content: message.content, author: message.author == "Ovum" ? "Ovum" : authViewModel.currentUser!.name)
                                        }
                                        if (awaitingResponse) {
                                            TypingIndicator()
                                                .frame(width: 80, height: 40, alignment: .leading)
                                                .id("typingIndicator")
                                        }
                                        VStack(spacing: 0) {
                                            Rectangle()
                                                .fill(AppColours.brown)
                                                .frame(height: 1)
                                                .id("bottomRect")
                                            Rectangle()
                                                .fill(AppColours.brown)
                                                .frame(height: 1)
                                                .id("bottomRect2")
                                        }
                                    }
                                    .opacity(viewModel.isLoading ? 0.5 : 1.0)
//                                    .padding([.bottom], 10)
                                    .background(GeometryReader { geometry in
                                        Color.clear
                                            .preference(key: ScrollViewHeightPreferenceKey.self, value: geometry.size.height)
                                    })
                                    .onPreferenceChange(ScrollViewHeightPreferenceKey.self) { scrollViewHeight = $0
                                        withAnimation {
                                            scrollViewProxy.scrollTo("bottomRect2", anchor: .top)
                                        }
                                    }
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
                                    .onChange(of: keyboard.currentHeight) {
                                        if (keyboard.currentHeight >= 370) {
                                            print("Hey")
                                            withAnimation {
                                                scrollViewProxy.scrollTo("bottomRect", anchor: .bottom)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            Text("Finished logging your symptom?")
                                .font(.subheadline)
                            Button {
                                sessionJustFinished = true
                            } label: {
                                Text("Save to Ovum")
                                    .font(.subheadline)
                                    .padding(10)
                                    .background(AppColours.green)
                                    .opacity(viewModel.currentSession.messages.count < 2 ? 0.5 : 1.0)
                                    .cornerRadius(6)
                            }
                            .disabled(viewModel.currentSession.messages.count < 2 || viewModel.isLoading)
                        }
                        .padding(.top, 3)
                        .padding(.bottom, 20)
                    }
                    .padding([.horizontal], 20)
                    .onTapGesture {
                        self.endEditing()
                    }
                    
                    Divider()
                        .background(AppColours.maroon)
                    SendMessageField(textInput: $inputText, isDisabled: awaitingResponse) {
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
                    .padding([.top], 15)
                    .padding([.bottom], 25)
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
            .alert("Are you sure you want to exit?", isPresented: $isExitAttempted) {
                VStack {
                    Button("Exit", role: .destructive) {
                        Task {
                            let _ = await viewModel.endSession(save: false, userId: authViewModel.currentUser!.id)
                            dismiss()
                        }
                    }
                    Button("No, let's continue chatting", role: .cancel) { }
                }
            } message: {
                Text("This conversation won’t be saved to Ovum.")
            }
            .alert("Are you sure you want log these symptoms?", isPresented: $sessionJustFinished) {
                HStack {
                    Button("Cancel", role: .destructive) { }
                    Button("Yes", role: .cancel) {
                        Task {
                            viewModel.isLoading = true
                            await viewModel.summariseConversation(authorId: authViewModel.currentUser!.id, authorName: authViewModel.currentUser!.name, HKM: healthKitManager)
                            let finishedSession = await viewModel.endSession(save: true, userId: authViewModel.currentUser!.id)
                            //                            let summary: String = viewModel.currentSession.summary ?? ""
                            viewModel.isLoading = false
                            router.navigateWithinChat(to: .chatComplete(session: finishedSession!)) // Will not be nil here.
                        }
                    }
                }
            } message: {
                Text("This conversation will end and a summary will be saved to your Ovum health record.")
            }
        }
        .ignoresSafeArea(.all, edges: Edge.Set(Edge.top))
        .ignoresSafeArea(.container, edges: Edge.Set(Edge.bottom))
//        .ignoresSafeArea(.ke)
    }
}

struct ScrollViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ChatDetail()
        .environmentObject(MessageViewModel(userId: "1", authViewModelPassedIn: AuthViewModel()))
        .environmentObject(AuthViewModel())
        .environmentObject(Router())
}
