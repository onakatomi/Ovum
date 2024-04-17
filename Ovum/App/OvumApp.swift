import SwiftUI
import Firebase
//import UXCamSwiftUI
//import UXCam

@main
struct OvumApp: App {
    @StateObject var router = Router() // create a model instance. initializes state in an app only once during the lifetime of the app.
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var healthKitManager = HealthKitManager()
    
    init() {
//        UXCam.optIntoSchematicRecordings()
//        let config = UXCamSwiftUI.Configuration(appKey: "fcjwoz22b3ns516")
//        UXCamSwiftUI.start(with: config)
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
