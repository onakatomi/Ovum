import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? // Tell us if we have a user logged in or not when we open the app
    @Published var currentUser: User? // Our user object
    
    init() {
        
    }
    
    // new async throws replaces URLSessions. completion blocks which aren't great
    func signIn(withEmail email: String, password: String) async throws {
        
    }
    
    func createUser(withEmail email: String, password: String, fullName: String) async throws {
        
    }
    
    func signOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        
    }
}
