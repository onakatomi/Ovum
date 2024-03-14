import SwiftUI

struct UploadDocument: View {
    @Binding var documentTitle: String
    @Binding var documentType: DocumentType
    
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                    HStack(spacing: 14) {
                        Image(systemName: "square.and.arrow.up")
                        PhotoPicker(documentTitle: $documentTitle, documentType: $documentType)
                    }
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.49, green: 0.27, blue: 0.18), lineWidth: 1)
                                .fill(Color(.clear))
                        )
                Button {
                    print("add doc")
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "camera")
                        CaptureImage(documentTitle: $documentTitle, documentType: $documentType)
                    }
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.49, green: 0.27, blue: 0.18), lineWidth: 1)
                                .fill(Color(.clear))
                        )
                }
            }
                .padding(.vertical, 32)
            Image("mail")
            Spacer().frame(height: 12)
            Text("Or have your clinic email them to")
                .font(Font.body)
            Text("D327THY1@ovum.com.au")
                .font(Font.headline)
        }
    }
}
