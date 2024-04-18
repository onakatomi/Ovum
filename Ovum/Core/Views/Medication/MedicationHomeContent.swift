import SwiftUI

struct MedicationHomeContent: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: MessageViewModel
    
    func getHomeScreenMedications() -> [Medication] {
        var onGoings = viewModel.currentMedication
        let filteredShortTerms = viewModel.pastMedication.filter { medication in
            Date.now >= medication.courseEnd!.addingTimeInterval(-Double((86400*Int(medication.howLongTakingFor!)!))) && Date.now <= medication.courseEnd!
        }
        return onGoings + filteredShortTerms
    }
    
    var body: some View {
        VStack {
            if (getHomeScreenMedications().count == 0) {
                    Text("*No recorded ongoing medication*")
                        .font(.caption)
                        .foregroundColor(AppColours.maroon)
                        .padding(.vertical, 40)
            }
            ScrollView {
                ForEach(getHomeScreenMedications()) { medication in
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
