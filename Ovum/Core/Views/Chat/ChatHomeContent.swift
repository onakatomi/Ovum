import SwiftUI

struct ChatHomeContent: View {
    func viewChatHistory() { print("hey") }
    @State private var textInput = ""
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
            VStack(spacing: 0) {
                Image("ovum_purple")
                    .padding([.top], 86)
                Text("Hi \(authViewModel.currentUser?.name ?? "there"). What symptoms are you experiencing at the moment?")
                    .font(.title)
                    .foregroundColor(Color(red: 0.49, green: 0.27, blue: 0.18))
                    .padding([.top], 16)
                    .multilineTextAlignment(.center)
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
