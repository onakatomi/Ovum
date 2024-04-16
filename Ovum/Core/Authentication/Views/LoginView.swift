import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn: Bool = false
    @State private var passwordResetEmail = ""
    @State private var showPasswordResetPopup: Bool = false
    @FocusState private var focusField: Bool
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("girl_smiling")
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 15, opaque: true)
                GeometryReader { geometry in
                    ScrollView {
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
                                InputView(text: $email, title: "Email Address", placeholder: "Enter your email", fieldIsFocused: $focusField)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true, fieldIsFocused: $focusField)
                                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            }
                            
                            Spacer()
                            
                            //                        .disabled(!formIsValid)
                            //                        .opacity(formIsValid ? 1.0 : 0.5)
                            
                            // Don't need value based setup here -- not clicking on object we destination for. View depricated but Link is not. We're just going from one place to another.
                            VStack {
                                PurpleButton(image: "upload", text: "Sign In") {
                                    Task {
                                        focusField = false
                                        isSigningIn = true
                                        try await authViewModel.signIn(withEmail: email, password: password)
                                        isSigningIn = false
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width - 32)
                                .padding(.bottom, 30)
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
                                Text("Forgot your password?")
                                    .foregroundColor(.white)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .onTapGesture {
                                        showPasswordResetPopup = true
                                    }
                            }
                        }
                        .padding(.vertical, 30)
                        .padding(.horizontal, 20)
                        .opacity(isSigningIn ? 0.5 : 1.0)
                        .alert("Reset Account Password", isPresented: $showPasswordResetPopup) {
                            TextField("Account email", text: $passwordResetEmail)
                                .textInputAutocapitalization(.never)
                            Button("Send Reset Email") {
                                authViewModel.sendPasswordReset(withEmail: passwordResetEmail)
                            }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Instructions on how to reset your password will be sent to the email you enter below.")
                        }
                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            print("hey")
//                            self.endEditing()
//                        }
                        .ignoresSafeArea(.keyboard)
                        .frame(minHeight: geometry.size.height)
                    }
                    .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
                }
                
                if isSigningIn {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppColours.mint))
                }
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
