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
    @Published var isAllUserDataFetched: Bool = false
    
    init() {
        self.userSession = Auth.auth().currentUser // Make when re-open app get the cached user Firebase stores on phone locally.
        
        // Fetch user on init
        Task {
            await fetchUser()
            await updateUser()
        }
    }
    
    // new async throws replaces URLSessions. completion blocks which aren't great
    func signIn(withEmail email: String, password: String) async throws -> String {
        print("Signing in...")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser() // Required to get logged in user from Firebase and updates currentUser
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            return ErrorMessages.invalidCredentials
        }
        
        return "Successful sign in"
    }
    
    // Async function that can potentially throw an error
    func createUser(withEmail email: String, password: String, name: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // Atempt to create user; await result
            self.userSession = result.user // Set userSession property with new user
            let user = User(id: result.user.uid, email: email, name: name, warningAccepted: false, onboardingInfo: nil, tokenUsage: 0) // Create OUR user object
            
//            let encodedUser = try Firestore.Encoder().encode(user) // Encode this object
            // There's a collection of users, which contains documents of user ids. Each document id maps to a user object. setData sets this map to the id.
//            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) // Upload this to Firebase

            await setUser(user: user)
            await fetchUser() // Fetch data we just uploaded to Firebase.
        } catch AuthErrorCode.emailAlreadyInUse {
            return ErrorMessages.emailTaken
        } catch {
            let err: String = "DEBUG: Failed to create user with error \(error.localizedDescription)"
            print(err)
        }
        
        return "Successful account creation"
    }
    
    struct userResponse: Codable {
        var user: User
    }
    
    // Used to either create a fresh user in the backend, or update a user in the backend.
    func setUser(user: User) async {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonResultData = try jsonEncoder.encode(user)
            let jsonString = String(data: jsonResultData, encoding: .utf8)
            
            let endpoint = "/create_user"
            
            let dataToSend: [String: Any] = [
//                "user_id": user.id,
                "user_object": jsonString!
            ]
            
            if let url = URL(string: Urls.baseUrl + endpoint) {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(currentUser?.jwtToken! ?? "none")", forHTTPHeaderField: "Authorization")
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: dataToSend)
                    let (data, _) = try await URLSession.shared.data(for: request)
                    
                    // Handle response:
                    let apiResponse = try JSONDecoder().decode(userResponse.self, from: data)
                    let _ = apiResponse.user
                } catch {
                    print("Adding user to firestore failed:", error)
                }
            }
        } catch {
            print("Creating user failed:", error)
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
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    func deleteAccount() {
        
    }
    
    // Creates a fresh copy in the backend, and then fetches the result. Also ensures tokenUsage is not nil.
    func updateUser() async {
        guard let _ = Auth.auth().currentUser?.uid else { return } // Return from function if there's no current user; prevents moving to API call below.
        if (currentUser?.tokenUsage == nil) {
            currentUser?.tokenUsage = 0
        }
        
        await setUser(user: currentUser!)
        await fetchUser()
    }
    
    struct fetchUserResponse: Codable {
        var fetched_user: User
    }
    
    func getUserToken() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error {
                    print("FIREBASE: There was an error getting the user token: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else {
                    print("FIREBASE: Got user token")
                    continuation.resume(returning: idToken!)
                }
            }
        }
    }
    
    // Fetches a user object from the backend.
    func fetchUser() async {
        guard let _ = Auth.auth().currentUser?.uid else { return } // Return from function if there's no current user; prevents moving to API call below.
//        signOut()
//        return
        var token: String?
            do {
                let actualToken: String? = try await getUserToken()
                token = actualToken
            } catch {
                print(error)
            }
        
        
        let endpoint = "/fetch_user"
        
        if let url = URL(string: Urls.baseUrl + endpoint) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token!)", forHTTPHeaderField: "Authorization")
            
            do {
//                request.httpBody = try JSONSerialization.data(withJSONObject: dataToSend)
                let (data, response) = try await URLSession.shared.data(for: request)
                let http = response as! HTTPURLResponse
                print("did fetch user, status: \(http.statusCode), count: \(data.count)")
                if http.statusCode == 404 {
                    print("404 fetch user")
                    return
                }
                
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(fetchUserResponse.self, from: data) // Decode the incoming JSON into a Swift struct
                self.currentUser = apiResponse.fetched_user
                self.currentUser?.jwtToken = token
                
                print("DEBUG: Current user is \(String(describing: self.currentUser?.id ?? nil))")
            } catch {
                print("GET request for fetching user failed:", error)
            }
        }
    }
}
