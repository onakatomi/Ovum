import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var healthKitManager: HealthKitManager
    
    var body: some View {
        ZStack {
            if (authViewModel.userSession == nil || authViewModel.currentUser?.id == nil) {
                LoginView()
            } else {
                // With user's ID, instantiate the main repository.
                LoggedInView(viewModel: MessageViewModel(userId: authViewModel.currentUser!.id, authViewModelPassedIn: authViewModel))
                    .environmentObject(authViewModel)
                    .environmentObject(router)
                    .environmentObject(healthKitManager)
            }
            
            if !authViewModel.isAllUserDataFetched {
                SplashScreen()
                    .ignoresSafeArea()
            }
        }
    }
}
