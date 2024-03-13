import SwiftUI
import Firebase

@main
struct OvumApp: App {
    @State private var viewModel = MessageViewModel() // create a model instance. initializes state in an app only once during the lifetime of the app.
    @State private var router = Router() // create a model instance. initializes state in an app only once during the lifetime of the app.
    @StateObject var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(router: router)
//                .environment(router) // supply it access to the router.
                .environment(viewModel) // supply it to ContentView using the environment(_:) modifier.
                .environmentObject(authViewModel)
        }
    }
}
