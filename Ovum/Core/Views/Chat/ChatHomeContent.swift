import SwiftUI
import UserNotifications

struct ChatHomeContent: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: MessageViewModel
    func viewChatHistory() { print("hey") }
    @State private var textInput = ""
    
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
//                VStack {
//                    Button("Request Permission") {
//                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
//                            if success {
//                                print("All set!")
//                            } else if let error {
//                                print(error.localizedDescription)
//                            }
//                        }
//                    }
//
//                    Button("Schedule Notification") {
//                        let content = UNMutableNotificationContent()
//                        content.title = "Feed the cat"
//                        content.subtitle = "It looks hungry"
//                        content.sound = UNNotificationSound.default
//
//                        // show this notification five seconds from now
//                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//
//                        // choose a random identifier
//                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//                        // add our notification request
//                        UNUserNotificationCenter.current().add(request)
//                    }
//                }
                
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
                if (viewModel.latestThreadId != nil) {
                    Text("Current thread ID: \(viewModel.latestThreadId!)")
                }
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
