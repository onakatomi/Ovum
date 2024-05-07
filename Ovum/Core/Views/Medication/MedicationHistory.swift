import SwiftUI

struct MedicationHistory: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: MessageViewModel
    @Environment(\.dismiss) private var dismiss
    
    func getHistoryScreenMedications() -> [Medication] {
        let filteredHistorical = viewModel.pastMedication.filter { medication in
            medication.type == .noLongerTaking ||
            Date.now > medication.courseEnd! || // Past taken short term medications
            (medication.howLongTakingFor != "" && medication.howLongTakingFor != nil && Date.now <= medication.courseEnd!.addingTimeInterval(-Double((86400*Int(medication.howLongTakingFor!)!)))) // Future medications
        }
        return filteredHistorical
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("back_button")
                }
                Spacer()
                Button {
                    withAnimation {
                        router.navigateWithinMedication(to: .menu)
                    }
                } label: {
                    Image("menu_brown")
                }
            }
                .padding(.bottom, 18)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            HStack(alignment: .top) {
                Header(firstLine: "Medication", secondLine: "History", colour: AppColours.maroon, font: .custom(AppFonts.testDomaine, size: 42), bolded: false)
                Spacer()
                Button {
                    router.navigateToRoot(within: .chat)
                    router.navigateWithinChat(to: .chatDetail)
                } label: {
                    Image("medication_history")
                        .resizable()
                        .frame(width: 50, height: 41.0)
                }
            }
                .padding(.bottom, 16)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            Text("Previous")
                .font(Font.custom(AppFonts.haasGrot, size: 24))
                .foregroundColor(AppColours.darkBrown)
                .padding(.bottom, 10)
            if (getHistoryScreenMedications().count == 0) {
                    Text("*No recorded past medication*")
                        .font(.caption)
                        .foregroundColor(AppColours.maroon)
                        .padding(.vertical, 40)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(getHistoryScreenMedications()) { pastMedication in
                        MedicationTile(medication: pastMedication)
                    }
                    .animation(.default, value: viewModel.pastMedication)
                }
            }
        }
        .padding(.horizontal, 20)
        .background {
            AppColours.brown
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .uxcamTagScreenName("MedicationHistoryScreen")
    }
}

//#Preview {
//    ChatHistory()
//        .environmentObject(MessageViewModel(userId: "1"))
//}
