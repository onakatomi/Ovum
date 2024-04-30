import SwiftUI
import Firebase
import UXCamSwiftUI
import UXCam

@main
struct OvumApp: App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    
    @StateObject var router = Router() // create a model instance. initializes state in an app only once during the lifetime of the app.
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var healthKitManager = HealthKitManager()
    
    init() {
        UXCam.optIntoSchematicRecordings()
        if let UXCamKey = Bundle.main.infoDictionary?["UXCAM_KEY"] as? String {
            print(UXCamKey)
            let config = UXCamSwiftUI.Configuration(appKey: UXCamKey)
            config.enableAutomaticScreenNameTagging = true
            UXCamSwiftUI.start(with: config)
        } else {
            print("Not reached....")
        }
        
//        UXCam.optIntoSchematicRecordings()
//        let config = UXCamSwiftUI.Configuration(appKey: "fcjwoz22b3ns516")
//        config.enableAutomaticScreenNameTagging = true
//        UXCamSwiftUI.start(with: config)
        
        if let path = Bundle.main.infoDictionary?["GOOGLE_PLIST_PATH"] as? String {
            print("Using google service plist from \(path)")
            FirebaseApp.configure(options: FirebaseOptions(contentsOfFile: Bundle.main.path(forResource: path, ofType: "plist")!)!)
        }
//        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.sizeCategory, .medium)
                .environmentObject(authViewModel)
                .environmentObject(router)
                .environmentObject(healthKitManager)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .portrait
    }
}
