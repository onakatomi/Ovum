import SwiftUI

struct Menu: View {
    @Environment(\.dismiss) private var dismiss
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
                //                Text("Research and Studies")
                //                    .foregroundColor(.white)
                //                    .font(Font.largeTitle.weight(.bold))
                //                    .frame(maxWidth: .infinity, alignment: .leading)
                //                ThickDivider(color: .white, width: 1, padding: 10)
                NavigationLink (destination: TotalChatSummaryView()) { // Hide tabbar whilst in MenuScreen.
                    Text("Medical Summary")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                //                NavigationLink {
                //
                //                } label: {
                //                    Text("About Ovum")
                //                        .foregroundColor(.white)
                //                        .font(Font.largeTitle.weight(.bold))
                //                        .frame(maxWidth: .infinity, alignment: .leading)                                    }
                
                ThickDivider(color: .white, width: 1, padding: 10)
                NavigationLink (destination: AboutOvumView()) { // Hide tabbar whilst in MenuScreen.
                    Text("About Ovum")
                        .foregroundColor(.white)
                        .font(Font.largeTitle.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                //                NavigationLink {
                //
                //                } label: {
                //                    Text("About Ovum")
                //                        .foregroundColor(.white)
                //                        .font(Font.largeTitle.weight(.bold))
                //                        .frame(maxWidth: .infinity, alignment: .leading)                                    }
                
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
                    //                    print("Signing Out")
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
        .uxcamTagScreenName("MenuScreen")
    }
}

#Preview {
    Menu()
}
