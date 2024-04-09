import SwiftUI

struct MedicationFrequency: View {
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) private var dismiss
    
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
                .navigationBarBackButtonHidden()
            }
            .padding(.bottom, 18)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 30)
            VStack(alignment: .leading, spacing: 15) {
                Text("How are you taking this medication?")
                    .font(.custom(AppFonts.haasGrot, size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(AppColours.buttonBrown)
                TransparentButton(text: "Ongoing", colour: AppColours.buttonBrown) {
                    router.navigateWithinMedication(to: .ongoing)
                }
                TransparentButton(text: "Short-term", colour: AppColours.buttonBrown) {
                    router.navigateWithinMedication(to: .shortTerm)
                }
                TransparentButton(text: "No longer taking", colour: AppColours.buttonBrown) {
                    router.navigateWithinMedication(to: .noLongerTaking)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background {
            AppColours.brown
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MedicationFrequency()
}
