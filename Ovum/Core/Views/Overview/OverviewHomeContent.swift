import SwiftUI

struct OverviewHomeContent: View {
    @StateObject var healthKitManager = HealthKitManager.shared
    
    var body: some View {
        VStack {
            Text("Today's steps: \(healthKitManager.stepCountToday)")
        }
    }
}



#Preview {
    OverviewHomeContent()
}
