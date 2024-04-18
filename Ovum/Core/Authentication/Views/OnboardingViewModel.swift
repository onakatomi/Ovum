import Foundation
import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var onboardingMessages: [Message] = [Message(author: "Ovum", fromOvum: true, content: "Hello! I'm Ovum, your women's health AI. To get started, I'll need to ask you a few onboarding questions about your health history. This should take just a few minutes.\n\nFirst things first, what’s your year of birth?")]
    
    let baseUrl = "https://ovumendpoints-2b7tck4zpq-uc.a.run.app"
//    let baseUrl = "http://192.168.89.21:5002"
//    let baseUrl = "http://192.168.89.39:5002"
    
    func getOnboardingResponse(message: String, authorId: String, authorName: String, isFirstMessageInConversation: Bool) async {
        let endpoint = "/get_onboarding_response"
        
        let dataToSend: [String: Any] = [
            "user_id": authorId,
            "user_name": authorName,
            "message": message,
            "is_first_message": isFirstMessageInConversation
        ]
        
        if let url = URL(string: baseUrl + endpoint) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: dataToSend)
                let (data, _) = try await URLSession.shared.data(for: request)
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(Response.self, from: data) // Decode the incoming JSON into a Swift struct
                let responseMessage: Message = Message(author: "Ovum", fromOvum: true, content: apiResponse.response)
                onboardingMessages.append(responseMessage)
            } catch {
                print("POST Request Failed:", error)
            }
        }
    }
    
    func concludeOnboarding() -> [String] {
        var userInfo: [String] = []
        // Starting at index 1 and continuing to the end of the array, with a step of 2
        for index in stride(from: 1, to: onboardingMessages.count, by: 2) {
            userInfo.append(onboardingMessages[index].content)
        }
        onboardingMessages.removeSubrange(1...)
        
        return userInfo
    }
}
