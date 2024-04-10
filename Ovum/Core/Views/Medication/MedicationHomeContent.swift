import SwiftUI

struct MedicationHomeContent: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: MessageViewModel
    
    var body: some View {
        VStack {
            if (viewModel.currentMedication.count == 0) {
                    Text("*No recorded ongoing medication*")
                        .font(.caption)
                        .foregroundColor(AppColours.maroon)
                        .padding(.vertical, 40)
            }
            ScrollView {
                ForEach(viewModel.currentMedication) { medication in
                    MedicationTile(medication: medication)
//                    NavigationLink(value: ChatNavDestination.chatHistoryDetail(session: chatSession)) {
//                        ChatTile(chatTile: chatSession)
//                    }
                }
            }
            Spacer()
            PurpleButton(image: "add_button_light_brown", text: "Add medication") {
                router.navigateWithinMedication(to: .medicationFrequency)
            }
            TransparentButton(text: "See medication history", colour: AppColours.darkBrown) {
                router.navigateWithinMedication(to: .medicationHistory)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
    }
}

#Preview {
    MedicationHomeContent()
        .environmentObject(Router())
        .environmentObject(MessageViewModel(userId: "1", authViewModelPassedIn: AuthViewModel()))
}
