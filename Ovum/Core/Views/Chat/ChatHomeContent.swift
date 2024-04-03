import SwiftUI

struct ChatHomeContent: View {
    func viewChatHistory() { print("hey") }
    @State private var textInput = ""
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: MessageViewModel
    
    var body: some View {
        
            VStack(spacing: 0) {
                Image("ovum_purple")
                    .padding([.top], 86)
                Text("Hi \(authViewModel.currentUser?.name ?? "there"). What symptoms are you experiencing at the moment?")
                    .font(Font.custom(AppFonts.testDomaine, size: 22))
                    .foregroundColor(AppColours.maroon)
                    .padding([.top], 16)
                    .multilineTextAlignment(.center)
                Spacer()
                Button {
                    Task {
                        viewModel.isNewThreadBeingGenerated = true
                        await viewModel.generateNewThread(userId: authViewModel.currentUser!.id)
                        viewModel.isNewThreadBeingGenerated = false
                    }
                } label: {
                    Text(viewModel.isNewThreadBeingGenerated ? "Creating..."  : "New Thread")
                        .font(.subheadline)
                        .padding(10)
                        .background(viewModel.isNewThreadBeingGenerated ? AppColours.maroon : AppColours.green)
                        .opacity(viewModel.isNewThreadBeingGenerated ? 0.5 : 1.0)
                        .cornerRadius(6)
                        .disabled(viewModel.isNewThreadBeingGenerated)
                }
                Spacer()
                Divider()
                VStack {
                    NavigationLink(value: ChatNavDestination.chatDetail) {
                        SendMessageField(textInput: $textInput, isDisabled: true)
                            .padding([.top], 15)
                            .padding([.bottom], 15)
                    }
                }
            }
            .padding([.horizontal], 20)

            .navigationBarBackButtonHidden(true)
    }
}
