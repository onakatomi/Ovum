import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @State var isSplashActive: Bool = true
    
    var body: some View {
        ZStack {
            if (authViewModel.userSession == nil || authViewModel.currentUser?.id == nil) {
                LoginView()
            } else {
                // With user's ID, instantiate the main repository.
                LoggedInView(viewModel: MessageViewModel(userId: authViewModel.currentUser!.id))
                    .environmentObject(authViewModel)
                    .environmentObject(router)
            }
            if isSplashActive {
                SplashScreen()
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    self.isSplashActive = false
                }
            }
        }
    }
}
