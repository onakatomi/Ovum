import SwiftUI
import PhotosUI

struct CaptureImage: View {
    @Environment(MessageViewModel.self) var viewModel
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    
    var body: some View {
        VStack {
            Button("Open camera") {
                self.showCamera.toggle()
            }
                .fullScreenCover(isPresented: self.$showCamera) {
                    accessCameraView(selectedImage: self.$selectedImage)
                        .ignoresSafeArea()
                }
            
            if let selectedImage{
                HStack {
                    Text("Document successfully uploaded")
                    Image(systemName: "checkmark.seal.fill")
                }
                    .foregroundColor(.green)
                    .onAppear {
                        let b64_rep = imageToBase64(selectedImage)
                        viewModel.addDocument(document: Document(title: "Document \(viewModel.documents.count + 1)", date: getDateAsString(date: Date.now), type: RecordType.pathology, file: b64_rep!))
                    }
            }
        }
    }
}


struct accessCameraView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var isPresented
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

// Coordinator will help to preview the selected image in the View.
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: accessCameraView
    
    init(picker: accessCameraView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}

#Preview {
    CaptureImage()
}
