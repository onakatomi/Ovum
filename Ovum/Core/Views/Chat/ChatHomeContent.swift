import SwiftUI
import UserNotifications

struct ChatHomeContent: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: MessageViewModel
    func viewChatHistory() { print("hey") }
    @State private var textInput = ""
    @State private var sliderValue: Double = .zero
    
    var body: some View {
        
            VStack(spacing: 0) {
                Image("ovum_purple")
                    .padding([.top], 86)
                
                Text("Welcome \(authViewModel.currentUser?.name ?? "").\nStart a chat to log a symptom.")
                    .font(Font.custom(AppFonts.testDomaine, size: 22))
                    .foregroundColor(AppColours.maroon)
                    .padding([.top], 16)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Divider()
                
                VStack {
                    NavigationLink(value: ChatNavDestination.chatDetail) {
                        Text("Speak with Ovum")
                            .font(.custom(AppFonts.haasGrot, size: 16))
                            .foregroundColor(AppColours.buttonBrown)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.86, green: 0.84, blue: 0.98))
                                .stroke(AppColours.buttonBrown, lineWidth: 1)
                        )
                    }
                    .padding([.bottom], 20)
                }
            }
            .padding([.horizontal], 20)
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ChatHomeContent()
        .environmentObject(MessageViewModel(userId: "1", authViewModelPassedIn: AuthViewModel()))
        .environmentObject(Router())
        .environmentObject(AuthViewModel())
}
