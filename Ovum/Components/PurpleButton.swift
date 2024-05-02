import SwiftUI

struct PurpleButton: View {
    
    var image: String? = nil
    let text: String
    let handler: (() -> Void)
    
    var body: some View {
        Button {
            handler()
        } label: {
            HStack(spacing: 14) {
                if image != nil {
                    Image(image!)                    
                }
                Text(text)
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.86, green: 0.84, blue: 0.98))
            )
        }
    }
}

#Preview {
    PurpleButton(image: "export", text: "Export overview for doctor") {
        print("TODO")
    }
}
