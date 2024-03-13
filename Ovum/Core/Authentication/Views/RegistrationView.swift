import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack {
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                InputView(text: $fullname, title: "Full Name", placeholder: "Enter your name")
                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
            }
                .padding(.horizontal)
            PurpleButton(image: "upload", text: "Sign Up") {
                print("Signing up...")
            }
                .frame(width: UIScreen.main.bounds.width - 32)
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
    }
}

#Preview {
    RegistrationView()
}
