import SwiftUI
import Firebase

@main
struct OvumApp: App {
    @StateObject var router = Router() // create a model instance. initializes state in an app only once during the lifetime of the app.
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var healthKitManager = HealthKitManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(router)
                .environmentObject(healthKitManager)
        }
    }
}
