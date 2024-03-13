import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
//                Image("girl_smiling")
                AppColours.brown
//                PurpleButton(image: <#T##String#>, text: <#T##String#>, handler: <#T##(() -> Void)##(() -> Void)##() -> Void#>)
                VStack {
                    VStack {
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    }
                        .padding(.horizontal)

                    PurpleButton(image: "upload", text: "Sign In") {
                        print("Signing in...")
                    }
                        .frame(width: UIScreen.main.bounds.width - 32)

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
                    }
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
