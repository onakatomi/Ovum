import SwiftUI

struct ErrorMessages {
    static let passwordTooShort: String = "Password must be 8 or more characters"
    static let passwordsDoNotMatch: String = "Passwords do not match"
    static let emailNotValid: String = "Please enter a valid email"
    static let emailTaken: String = "This email is already registered"
    static let nameNotValid: String = "Please enter a valid name"
}

struct RegistrationView: View {
    @State private var email = ""
    @State private var name = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isCreatingUser: Bool = false
    @State private var errorMessages: [String] = []
    @State private var showingAlert = false
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
                        .onChange(of: email) {
                            if (email.count > 0 && !email.contains("@")) {
                                if !errorMessages.contains(ErrorMessages.emailNotValid) {
                                    errorMessages.append(ErrorMessages.emailNotValid)
                                }
                            } else {
                                if let index = errorMessages.firstIndex(of: ErrorMessages.emailNotValid) {
                                    errorMessages.remove(at: index)
                                }
                            }
                        }
                    
                    InputView(text: $name, title: "Name", placeholder: "Your name", fieldIsFocused: $focusField)
                        .autocapitalization(.words)
                        .onChange(of: name) {
                            if ((name.count > 0 && name.count < 3) || name == "Ovum") {
                                if !errorMessages.contains(ErrorMessages.nameNotValid) {
                                    errorMessages.append(ErrorMessages.nameNotValid)
                                }
                            } else {
                                if let index = errorMessages.firstIndex(of: ErrorMessages.nameNotValid) {
                                    errorMessages.remove(at: index)
                                }
                            }
                        }
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true, fieldIsFocused: $focusField)
                        if !password.isEmpty {
                            if password.count > 7 {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                                    .padding(.trailing, 10)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true, fieldIsFocused: $focusField)
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                                    .padding(.trailing, 10)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                    .onChange(of: [password, confirmPassword]) {
                        if (password != confirmPassword && confirmPassword.count > 0) {
                            if !errorMessages.contains(ErrorMessages.passwordsDoNotMatch) {
                                errorMessages.append(ErrorMessages.passwordsDoNotMatch)
                            }
                        } else if (password == confirmPassword && confirmPassword.count > 0) {
                            if let index = errorMessages.firstIndex(of: ErrorMessages.passwordsDoNotMatch) {
                                errorMessages.remove(at: index)
                            }
                        }
                        
                        if (password.count < 8) {
                            if !errorMessages.contains(ErrorMessages.passwordTooShort) {
                                errorMessages.append(ErrorMessages.passwordTooShort)
                            }
                        } else {
                            if let index = errorMessages.firstIndex(of: ErrorMessages.passwordTooShort) {
                                errorMessages.remove(at: index)
                            }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(errorMessages, id: \.self) { error in
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                            Text(error)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                    .animation(.default, value: errorMessages)
                }
                .padding(.vertical, 5)
                
                Spacer()
                
                PurpleButton(image: "upload", text: "Sign Up") {
                    Task {
                        focusField = false
                        isCreatingUser = true
                        let result = try await authViewModel.createUser(withEmail: email, password: password, name: name)
                        if result == ErrorMessages.emailTaken {
                            showingAlert = true
                        }
                        isCreatingUser = false
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
            .opacity(isCreatingUser ? 0.5 : 1.0)
            .alert("This email is already taken", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
            
            if isCreatingUser {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColours.mint))
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && name.count > 2
        && name != "Ovum"
        && !password.isEmpty
        && password.count > 7
        && confirmPassword == password
    }
}

#Preview {
    RegistrationView()
}
