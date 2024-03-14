import SwiftUI
import PhotosUI

struct PhotoPicker: View {
    @Binding var documentTitle: String
    @Binding var documentType: DocumentType
    
    @Environment(MessageViewModel.self) var viewModel
    @State private var selectedItem: PhotosPickerItem?
    @State var image: UIImage?
   
    var body: some View {
    
        VStack {
            PhotosPicker("Select an image", selection: $selectedItem, matching: .images)
                .onChange(of: selectedItem) {
                    Task {
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            image = UIImage(data: data)
                            let b64_rep = imageToBase64(image!)
                            viewModel.addDocument(document: Document(title: documentTitle, date: getDateAsString(date: Date.now), type: documentType, file: b64_rep!))
                        }
                    }
                }
            
            if (image != nil)  {
                HStack {
                    Text("Document successfully uploaded")
                    Image(systemName: "checkmark.seal.fill")
                }
                    .foregroundColor(.green)
            }
        }
    }
}
