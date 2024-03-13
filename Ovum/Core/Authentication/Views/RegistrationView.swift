import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @FocusState private var focusField: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Image("girl_smiling")
                .resizable()
                .ignoresSafeArea()
                .blur(radius: 15, opaque: true)
            VStack {
                Text("Sign Up")
                    .foregroundColor(Color(.white))
                    .fontWeight(.semibold)
//                        .font(.largeTitle)
                    .font(.system(size: 50))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ThickDivider(color: Color(.white), width: 1, padding: 0)
                    .padding(.bottom, 15)
                VStack {
                    Text("Let’s get you started")
                        .fontWeight(.light)
                        .foregroundColor(Color(.white))
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("with your account")
                        .foregroundColor(Color(.white))
                        .fontWeight(.light)
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 30)
                VStack(spacing: 15) {
                    InputView(text: $email, title: "Email Address", placeholder: "Your email", fieldIsFocused: $focusField)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true, fieldIsFocused: $focusField)
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true, fieldIsFocused: $focusField)
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                
                Spacer()
                
                PurpleButton(image: "upload", text: "Sign Up") {
                    Task {
                        try await authViewModel.createUser(withEmail: email,
                                                           password: password)
                    }
                    print("Signing up...")
                }
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .padding(.bottom, 30)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Text("Have an account?")
                        Text(" Sign in.")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
    }
}

#Preview {
    RegistrationView()
}
