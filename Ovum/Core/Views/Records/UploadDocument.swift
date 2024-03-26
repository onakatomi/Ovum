import SwiftUI

struct UploadDocument: View {
    
    var body: some View {
        VStack {
            VStack(spacing: 12) {
                HStack(spacing: 14) {
                    Image(systemName: "square.and.arrow.up")
                    PhotoPicker()
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
                        CaptureImage()
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
        }
    }
}
