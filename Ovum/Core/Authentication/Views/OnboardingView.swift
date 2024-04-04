import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var lifecycle = ""
    @State var birthDate = Date()
    @State private var isPregnant = false
    @FocusState private var focusField: Bool
    @State private var isPushingInformation: Bool = false
    
    var body: some View {
        ZStack {
            Image("girl_smiling")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 15, opaque: true)
            VStack {
                Text("Onboarding Questions")
                    .foregroundColor(Color(.white))
                    .fontWeight(.semibold)
//                        .font(.largeTitle)
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ThickDivider(color: Color(.white), width: 1, padding: 0)
                    .padding(.bottom, 15)
                
                InputView(text: $lifecycle, title: "Lifecycle", placeholder: "Stage in your lifecycle", fieldIsFocused: $focusField)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                    Text("Choose your birthday")
                }
                .foregroundColor(.white)
                Toggle(isOn: $isPregnant) {
                    Text("Are you currently pregnant?")
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                PurpleButton(image: "upload", text: "Continue") {
                    Task {
                        focusField = false
                        isPushingInformation = true
                        try await authViewModel.collectOnboardingInformation(dob: birthDate.description, isPregnant: isPregnant, lifecycle: lifecycle)
                        isPushingInformation = false
                    }
                    print("Signing up...")
                }
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .padding(.bottom, 30)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .opacity(isPushingInformation ? 0.5 : 1.0)
            
            if isPushingInformation {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColours.mint))
            }
        }
    }
}

extension OnboardingView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !lifecycle.isEmpty
    }
}

#Preview {
    OnboardingView()
}
