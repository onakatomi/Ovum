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
                
                Spacer()
                
                Button {
                    //                    dismiss()
                    router.navigateBack(within: router.selectedTab)
                    //                    router.navigateToRoot(within: .overview)
                    router.navigateToRoot(within: .chat)
                    //                    router.navigateToRoot(within: .records)
                    router.navigateWithinChat(to: .chatHistory)
                } label: {
                    Text("Chat History")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 10)
                
                NavigationLink (destination: TotalChatSummaryView()) { // Hide tabbar whilst in MenuScreen.
                    Text("Medical Summary")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 10)
                
                Button {
                    openURL(URL(string: "https://www.ovum-ai.com.au/about")!)
                } label: {
                    Text("About Ovum")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 10)
                
                Button {
                    openURL(URL(string: "https://c5rxwa4obav.typeform.com/to/AvYgfWTO")!)
                } label: {
                    Text("Need Help?")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                ThickDivider(color: .white, width: 1, padding: 10)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 10) {
                    Button {
                        Task {
                            viewModel.isNewThreadBeingGenerated = true
                            await viewModel.generateNewThread(userId: authViewModel.currentUser!.id)
                            viewModel.isNewThreadBeingGenerated = false
                        }
                    } label: {
                        Text(viewModel.isNewThreadBeingGenerated ? "Creating..."  : "New Thread")
                            .font(.subheadline)
                            .padding(10)
                            .background(viewModel.isNewThreadBeingGenerated ? AppColours.maroon : AppColours.green)
                            .opacity(viewModel.isNewThreadBeingGenerated ? 0.5 : 1.0)
                            .cornerRadius(6)
                            .disabled(viewModel.isNewThreadBeingGenerated)
                    }
                    
                    Text("Current thread ID:\n**\(viewModel.latestThreadId)**")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("User ID:\n**\(authViewModel.currentUser?.id ?? "none")**")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Text("Email: **\(authViewModel.currentUser?.email ?? "none")**")
                        .foregroundColor(.white)
                }
                .padding(.vertical, 10)
                
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
