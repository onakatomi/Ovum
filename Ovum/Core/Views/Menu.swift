import SwiftUI

struct Menu: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            AppColours.darkBrown
            VStack(spacing: 0) {
                Button {
                    dismiss()
                } label: {
                    Image("add_button_white")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button {
                    router.navigateToRoot(within: .overview)
                    router.navigateToRoot(within: .chat)
                    router.navigateToRoot(within: .records)
                    router.navigateWithinChat(to: .chatHistory)
                } label: {
                    Text("Chat History")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 10)
                Text("Research and Studies")
                    .foregroundColor(.white)
                    .font(Font.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ThickDivider(color: .white, width: 1, padding: 10)
                Text("About Ovum")
                    .foregroundColor(.white)
                    .font(Font.largeTitle.weight(.bold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                ThickDivider(color: .white, width: 1, padding: 10)
                Text("Settings")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .font(Font.largeTitle.weight(.bold))
                ThickDivider(color: .white, width: 1, padding: 10)
                Spacer()
                PurpleButton(image: "export", text: "Export overview for doctor") {
                    print("TODO")
                }
                .padding(.bottom, 15)
                TransparentButton(text: "Sign Out", colour: Color(.white)) {
                    print("Signing Out")
                    authViewModel.signOut()
                }
                .padding(.bottom, 30)
                SecondaryButton(text: "Privacy Policy") {
                    print("TODO")
                }
                SecondaryButton(text: "Terms of Use") {
                    print("TODO")
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 50)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Menu()
}
