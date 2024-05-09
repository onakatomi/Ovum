import SwiftUI

struct DebugScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var healthKitManager: HealthKitManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("back_button")
                }
                Spacer()
            }
            .padding(.bottom, 18)
            
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 9) {
                Text("Debug Information")
                    .font(.custom(AppFonts.haasGrot, size: 42))
                    .fontWeight(.bold)
                    .foregroundColor(AppColours.darkBrown)
            }
            .padding(.bottom, 16)
            
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            
            VStack(alignment: .center, spacing: 10) {
                Text(.init(healthKitManager.summariseCurrentData()))
                Button {
                    Task {
                        viewModel.isNewThreadBeingGenerated = true
                        await viewModel.generateNewThread(userId: authViewModel.currentUser!.id)
                        viewModel.isNewThreadBeingGenerated = false
                    }
                } label: {
                    Text(viewModel.isNewThreadBeingGenerated ? "Creating..."  : "New Thread")
                        .font(.subheadline)
                        .padding(10)
                        .background(viewModel.isNewThreadBeingGenerated ? AppColours.maroon : AppColours.green)
                        .opacity(viewModel.isNewThreadBeingGenerated ? 0.5 : 1.0)
                        .cornerRadius(6)
                        .disabled(viewModel.isNewThreadBeingGenerated)
                }
                
                Text("Current thread ID:\n**\(viewModel.latestThreadId)**")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("User ID:\n**\(authViewModel.currentUser?.id ?? "none")**")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                Text("Email: **\(authViewModel.currentUser?.email ?? "none")**")
                    .foregroundColor(.black)
            }
            .padding(.vertical, 10)
            
            Spacer()
        }
        .onAppear {
            healthKitManager.requestAuthorization()
        }
        .padding(.horizontal, 20)
        .background {
            AppColours.brown
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .uxcamTagScreenName("DebugScreen")
    }
}

#Preview {
    DebugScreen()
        .environmentObject(MessageViewModel(userId: "1", authViewModelPassedIn: AuthViewModel()))
        .environmentObject(AuthViewModel())
        .environmentObject(HealthKitManager())
}
