import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var healthKitManager: HealthKitManager
    @StateObject var ovm = OnboardingViewModel()
    @State var showSlowPopup: Bool = false
    
    var body: some View {
        ZStack {
            if (authViewModel.userSession == nil || authViewModel.currentUser?.id == nil || authViewModel.currentUser?.jwtToken == nil) {
                LoginView()
            } else {
                // With user's ID, instantiate the main repository.
                LoggedInView(viewModel: MessageViewModel(userId: authViewModel.currentUser!.id, authViewModelPassedIn: authViewModel))
                    .environmentObject(authViewModel)
                    .environmentObject(router)
                    .environmentObject(healthKitManager)
            }
            
            if (((authViewModel.userSession != nil || authViewModel.currentUser?.id != nil) && !authViewModel.isAllUserDataFetched)) {
                SplashScreen()
                    .ignoresSafeArea()
                    .onAppear() {
                        scheduleAppReminderNotification()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            withAnimation {
                                self.showSlowPopup = true
                            }
                        }
                    }
                    .alert("Check your internet connection", isPresented: $showSlowPopup) {
                        Button("OK", role: .cancel) { }
                    }
            }
            
            if (authViewModel.userSession != nil &&
                authViewModel.currentUser != nil &&
                authViewModel.currentUser!.warningAccepted == true &&
                authViewModel.currentUser!.onboardingInfo == nil) {
                    OnboardingView(ovm: ovm)
                        .environmentObject(authViewModel)
                        .environmentObject(router)
            }
            
            if (authViewModel.userSession != nil &&
                authViewModel.currentUser != nil &&
                (authViewModel.currentUser!.warningAccepted == nil || authViewModel.currentUser!.warningAccepted == false)) {
                WarningView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
