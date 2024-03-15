import SwiftUI

//enum DocumentType: CaseIterable, Identifiable, CustomStringConvertible {
//    case imaging
//    case pathology
//    case letter
//    
//    var id: Self { self }
//    
//    var description: String {
//        switch self {
//        case .imaging:
//            return "Imaging"
//        case .pathology:
//            return "Pathology"
//        case .letter:
//            return "Letter"
//        }
//    }
//}

struct AddDocumentTray: View {
    @State private var documentTitle = ""
    @State private var documentType: DocumentType = DocumentType.imaging
    
    @State var readyToUpload: Bool = false
    @FocusState private var focusField: Bool
    var body: some View {
        VStack(spacing: 0) {
            Text("Add documents")
                .font(Font.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer().frame(height: 12)
            Divider()
                .padding(.bottom, 20)
            if readyToUpload {
                UploadDocument(documentTitle: $documentTitle, documentType: $documentType)
                    .transition(.scale)
            } else {
                TagDocument(documentTitle: $documentTitle, documentType: $documentType, fieldIsFocused: $focusField)
            }
            Spacer()
            if (!readyToUpload) {
                PurpleButton(image: "arrow.right", text: "Choose Document") {
                    withAnimation {
                        readyToUpload.toggle()
                    }
                }
                .disabled(documentTitle == "")
                .opacity(documentTitle == "" ? 0.5 : 1.0)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .background(AppColours.brown)
    }
}

#Preview {
    RecordsHomeContent()
        .environment(MessageViewModel())
}
