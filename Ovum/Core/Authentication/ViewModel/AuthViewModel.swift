import Foundation
import Firebase
import FirebaseFirestoreSwift

// Multiple views with forms can conform to this
protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get } // Forms have to implement this formIsValid property and make it true.
}

@MainActor // We need to publish all UI updates back on the main thread. By default async updates occur on the background thread.
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? // Tell us if we have a user logged in or not when we open the app
    @Published var currentUser: User? // Our user object
    
    init() {
        self.userSession = Auth.auth().currentUser // Make when re-open app get the cached user Firebase stores on phone locally.
        
        // Fetch user on init
        Task {
            await fetchUser()
        }
    }
    
    // new async throws replaces URLSessions. completion blocks which aren't great
    func signIn(withEmail email: String, password: String) async throws {
        print("Signing in...")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser() // Required to get logged in user from Firebase and updates currentUser
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    // Async function that can potentially throw an error
    func createUser(withEmail email: String, password: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // Atempt to create user; await result
            self.userSession = result.user // Set userSession property with new user
            let user = User(id: result.user.uid, email: email, name: name) // Create OUR user object
            let encodedUser = try Firestore.Encoder().encode(user) // Encode this object
            // There's a collection of users, which contains documents of user ids. Each document id maps to a user object. setData sets this map to the id.
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) // Upload this to Firebase
            await fetchUser() // Fetch data we just uploaded to Firebase.
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() // Signs out user on backend.
            self.userSession = nil // Wipes out user session and takes us back to login screen. Presentation logic is based on userSession.
            self.currentUser = nil // Wipes out currentUser data model. When we sign in with another user we don't want old data.
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        print("Signing out...")
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // Return from function if there's no current user; prevents moving to API call below.
        
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        print("DEBUG: Current user is \(String(describing: self.currentUser ?? nil))")
    }
}
