import SwiftUI
import PhotosUI

struct PhotoPicker: View {
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
                            viewModel.addDocument(document: Document(title: "Medical Report", date: getDateAsString(date: Date.now), type: RecordType.pathology, file: b64_rep!))
                        }
//                        print("Failed to load the image")
                    }
                }
            
            if let image {
                HStack {
                    Text("Document successfully uploaded")
                    Image(systemName: "checkmark.seal.fill")
                }
                    .foregroundColor(.green)
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
            }
        }
//            .padding()
    }
}

#Preview {
    PhotoPicker()
}
