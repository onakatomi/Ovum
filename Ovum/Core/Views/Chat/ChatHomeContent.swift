import SwiftUI

struct ChatHomeContent: View {
    func viewChatHistory() { print("hey") }
    @State private var textInput = ""
    @EnvironmentObject var router: Router
    
    
    var body: some View {
        
            VStack(spacing: 0) {
                Image("ovum_purple")
                    .padding([.top], 86)
                Text("How can we help today?")
                    .font(.title)
                    .foregroundColor(Color(red: 0.49, green: 0.27, blue: 0.18))
                    .padding([.top], 16)
                Spacer()
                NavigationLink(value: ChatNavDestination.chatHistory) {
                    Text("View Chat History")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color(red: 0.49, green: 0.27, blue: 0.18))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.49, green: 0.27, blue: 0.18), lineWidth: 1)
                        )
                        .padding([.bottom], 30)
                }
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
