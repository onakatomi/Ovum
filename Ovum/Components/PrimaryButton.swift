import SwiftUI

struct PrimaryButton: View {
    let text: String
    let fill: Color
    let hasBorder: Bool
    let icon: Image?
    
    var body: some View {
        HStack(spacing: 14) {
            if let icon {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18.0, height: 18.0)
            }
            Text(text)
        }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background(Color(.white))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.3, green: 0.1, blue: 0.04), lineWidth: 1)
            )
    }
}

#Preview {
    PrimaryButton(text: "Import from your device", fill: Color.clear, hasBorder: true, icon: Image(systemName: "square.and.arrow.up"))
}
