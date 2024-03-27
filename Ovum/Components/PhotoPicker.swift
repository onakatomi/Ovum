import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?
    @State var isDocSuccessfullyUploaded: Bool = false
   
    var body: some View {
    
        VStack {
            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                            let b64_rep = imageToBase64(image!)
                            if let b64_rep {
                                viewModel.isDocumentUploading = true
                                await viewModel.analyseDocument(document: b64_rep, userId: authViewModel.currentUser!.id)
                                viewModel.isDocumentUploading = false
                                isDocSuccessfullyUploaded = true
                            }
                        }
                    }
                }
            
            if (isDocSuccessfullyUploaded)  {
                HStack {
                    Text("Document successfully uploaded")
                    Image(systemName: "checkmark.seal.fill")
                }
                    .foregroundColor(.green)
            }
        }
    }
}
