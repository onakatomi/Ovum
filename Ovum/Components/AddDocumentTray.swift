import SwiftUI

struct AddDocumentTray: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @FocusState private var focusField: Bool
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Add documents")
                    .font(Font.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer().frame(height: 12)
                Divider()
                    .padding(.bottom, 20)
                Spacer()
                Text("Before uploading, please ensure you have removed any personal information from your documents.")
                    .foregroundColor(AppColours.maroon)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 20)
                UploadDocument()
                    .transition(.scale)
                Spacer()
            }
            .opacity(viewModel.isDocumentUploading ? 0.5 : 1.0)
            .padding(.horizontal, 20)
            .padding(.vertical, 40)
            .background(AppColours.brown)
            
            if (viewModel.isDocumentUploading) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColours.maroon))
            }
        }
    }
}

#Preview {
    RecordsHomeContent()
        .environmentObject(MessageViewModel(userId: "1", authViewModelPassedIn: AuthViewModel()))
}
