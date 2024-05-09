import SwiftUI

struct Menu: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) var openURL
    @EnvironmentObject var router: Router
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: MessageViewModel
    //    let tab: ContentViewTab
    
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
                .padding(.bottom, 30)
                
//                Spacer()
                
                Button {
                    router.navigateBack(within: router.selectedTab)
                    router.navigateToRoot(within: .chat)
                    router.navigateWithinChat(to: .chatHistory)
                } label: {
                    Text("Chat History")
                        .foregroundColor(.white)
                        .font(.custom(AppFonts.haasGrot, size: 42))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 17)
                
                NavigationLink (destination: TotalChatSummaryView()) { // Hide tabbar whilst in MenuScreen.
                    Text("Medical Summary")
                        .foregroundColor(.white)
                        .font(.custom(AppFonts.haasGrot, size: 42))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 17)
                
                Button {
                    openURL(URL(string: "https://www.ovum-ai.com.au/about")!)
                } label: {
                    Text("About Ovum")
                        .foregroundColor(.white)
                        .font(.custom(AppFonts.haasGrot, size: 42))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 17)
                
                Button {
                    openURL(URL(string: "https://c5rxwa4obav.typeform.com/to/AvYgfWTO")!)
                } label: {
                    Text("Give Feedback")
                        .foregroundColor(.white)
                        .font(.custom(AppFonts.haasGrot, size: 42))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 17)
                
                if AppCheck.isInternal {
                    NavigationLink (destination: DebugScreen()) {
                        Text("Debug")
                            .foregroundColor(.white)
                            .font(.custom(AppFonts.haasGrot, size: 42))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    ThickDivider(color: .white, width: 1, padding: 17)                    
                }
                
                
                Spacer()
                
                TransparentButton(text: "Sign Out", colour: Color(.white)) {
                    router.navigateToRoot(within: .overview)
                    router.navigateToRoot(within: .medication)
                    router.navigateToRoot(within: .chat)
                    router.navigateToRoot(within: .records)
                    authViewModel.signOut()
                }
                .padding(.bottom, 30)
                VStack(alignment: .center, spacing: 10) {
                    SecondaryButton(text: "Privacy Policy") {
                        openURL(URL(string: "https://www.ovum-ai.com.au/privacy-policy")!)
                    }
                    SecondaryButton(text: "Terms of Use") {
                        openURL(URL(string: "https://www.ovum-ai.com.au/terms-of-use")!)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 50)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .uxcamTagScreenName("MenuScreen")
    }
}

#Preview {
    Menu()
}
