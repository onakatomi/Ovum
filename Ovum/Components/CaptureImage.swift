import SwiftUI
import PhotosUI

struct CaptureImage: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showCamera = false
    @State private var selectedImage: UIImage?
    @State var image: UIImage?
    @State var isDocSuccessfullyUploaded: Bool = false
    @State var docUploadFailed: Bool = false
    
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
                HStack {}
                    .onAppear {
                        let b64_rep = imageToBase64(selectedImage)
                        if let b64_rep {
                            Task {
                                viewModel.isDocumentUploading = true
                                let result = await viewModel.analyseDocument(document: b64_rep)
                                if result == 1 {
                                    docUploadFailed = true
                                } else {
                                    isDocSuccessfullyUploaded = true
                                }
                                viewModel.isDocumentUploading = false
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
            } else if (docUploadFailed) {
                HStack {
                    Text("Document upload failed")
                    Image(systemName: "xmark.seal.fill")
                }
                    .foregroundColor(.red)
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
