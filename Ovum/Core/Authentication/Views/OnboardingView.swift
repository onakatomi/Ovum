import SwiftUI

struct OnboardingView: View {
    enum FocusedField {
        case inputText
    }
    
    @ObservedObject var ovm: OnboardingViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var inputText: String = ""
    @FocusState private var textFieldIsFocused: Bool
    @State private var awaitingResponse: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var scrollViewHeight: CGFloat = 0
    
    var progressInterval: ClosedRange<Date> {
        let start = Date()
        let end = start.addingTimeInterval(3)
        return start...end
    }
    
    var body: some View {
        
        ZStack(alignment: .top) {
            Rectangle()
            ZStack(alignment: .top) {
                Image("chat")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 10, opaque: true)
                VStack(spacing: 10) {
                    Divider()
                        .background(Color(.white))
                    HStack(alignment: .top) {
                        Header(firstLine: "Onboarding", secondLine: "Questions", colour: Color(.white), font: .custom(AppFonts.haasGrot, size: 42))
                        Spacer()
                    }
                    
                    .padding([.top], 30)
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
                                        ForEach(ovm.onboardingMessages) { message in
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
                                    .opacity(ovm.isLoading ? 0.5 : 1.0)
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
                                    .onChange(of: ovm.onboardingMessages.count) {
                                        if (ovm.onboardingMessages.count != 0) {
                                            withAnimation {
                                                scrollViewProxy.scrollTo(ovm.onboardingMessages[ovm.onboardingMessages.count - 1].id, anchor: .top)
                                            }
                                        }
                                    }
                                    .onAppear {
                                        if (!ovm.onboardingMessages.isEmpty) {
                                            withAnimation {
                                                scrollViewProxy.scrollTo("bottomRect", anchor: .bottom)
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
                            Text("Impatient?")
                                .font(.subheadline)
                            Button {
                                Task {
                                    ovm.isLoading = true
                                    let info = ovm.concludeOnboarding()
                                    authViewModel.currentUser?.onboardingInfo = info
                                    await authViewModel.updateUser()
                                    try? await Task.sleep(nanoseconds: 1_000_000_000)
                                    ovm.isLoading = false
                                }
                            } label: {
                                Text("Finish onboarding early")
                                    .font(.subheadline)
                                    .padding(10)
                                    .background(AppColours.green)
                                    .opacity(ovm.onboardingMessages.count < 2 ? 0.5 : 1.0)
                                    .cornerRadius(6)
                            }
                            .disabled(ovm.onboardingMessages.count < 2 || ovm.isLoading)
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
                        awaitingResponse = true
                        let textCopy: String = inputText // Make copy so that message passed to API isn't blank.
                        self.inputText = "" // Reset text field.
                        let sentMessage = Message(author: authViewModel.currentUser!.id, fromOvum: false, content: textCopy) // Construct message model.
                        ovm.onboardingMessages.append(sentMessage)
                        
                        await ovm.getOnboardingResponse(message: textCopy, authorId: authViewModel.currentUser!.id, authorName: authViewModel.currentUser!.name, isFirstMessageInConversation: ovm.onboardingMessages.count == 1 ? true : false) // Get Ovum's response.
                        awaitingResponse = false
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
                //                .opacity(ovm.isLoading ? 0.5 : 1.0)
                if (ovm.isLoading) {
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
        }
        .ignoresSafeArea(.all, edges: Edge.Set(Edge.top))
        .ignoresSafeArea(.container, edges: Edge.Set(Edge.bottom))
//        .ignoresSafeArea(.ke)
    }
}

#Preview {
    OnboardingView(ovm: OnboardingViewModel())
        .environmentObject(AuthViewModel())
        .environmentObject(Router())
}
