import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("girl_smiling")
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 15, opaque: true)
                VStack {
                    Text("Sign In")
                        .foregroundColor(Color(.white))
                        .fontWeight(.semibold)
//                        .font(.largeTitle)
                        .font(.system(size: 50))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ThickDivider(color: Color(.white), width: 1, padding: 0)
                        .padding(.bottom, 15)
                    VStack {
                        Text("Welcome back")
                            .fontWeight(.light)
                            .foregroundColor(Color(.white))
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("to Ovum")
                            .foregroundColor(Color(.white))
                            .fontWeight(.light)
                            .font(.title3)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.bottom, 30)
                    VStack {
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                    
                    Spacer()

                    PurpleButton(image: "upload", text: "Sign In") {
                        Task {
                            try await authViewModel.signIn(withEmail: email, password: password)
                        }
                    }
                        .frame(width: UIScreen.main.bounds.width - 32)
//                        .disabled(!formIsValid)
//                        .opacity(formIsValid ? 1.0 : 0.5)

                    // Don't need value based setup here -- not clicking on object we destination for. View depricated but Link is not. We're just going from one place to another.
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        HStack {
                            Text("Don’t have an account?")
                            Text(" Sign up.")
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.vertical)
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
}
