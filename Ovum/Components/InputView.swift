import SwiftUI

struct InputView: View {
    @Binding var text: String
    
    let title: String
    let placeholder: String
    var isSecureField = false

    @FocusState.Binding var fieldIsFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .focused($fieldIsFocused)
                    .background(
                      RoundedRectangle(cornerRadius: 6)
                        .fill(.white)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .focused($fieldIsFocused)
                    .background(
                      RoundedRectangle(cornerRadius: 6)
                        .fill(.white)
                    )
            }
        }
    }
}

#Preview {
    LoginView()
}
