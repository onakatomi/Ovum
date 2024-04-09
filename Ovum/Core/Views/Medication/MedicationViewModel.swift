import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor // We need to publish all UI updates back on the main thread. By default async updates occur on the background thread.
class MedicationViewModel: ObservableObject {
    @Published var currentMedication: [Medication]
    @Published var pastMedication: [Medication]
    
    init() {
        currentMedication = []
        pastMedication = []
        
        // Fetch user on init
        Task {
//            await fetchUser()
        }
    }
    
    // Async function that can potentially throw an error
    func createMedication(withEmail email: String, password: String, name: String) async throws {
        do {
//            let user = User(id: result.user.uid, email: email, name: name) // Create OUR user object
//            let encodedUser = try Firestore.Encoder().encode(user) // Encode this object
//            // There's a collection of users, which contains documents of user ids. Each document id maps to a user object. setData sets this map to the id.
//            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) // Upload this to Firebase
        } catch {
            print("DEBUG: Failed to create medication with error \(error.localizedDescription)")
        }
    }
}
