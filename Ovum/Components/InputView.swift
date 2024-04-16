import SwiftUI

struct InputView: View {
    @Binding var text: String
    
    let title: String
    let placeholder: String
    var isSecureField = false
    var hasBorder = false

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
                        .stroke(AppColours.darkBrown, lineWidth: hasBorder ? 1 : 0)
                    )
                    .contentShape(Rectangle())
//                    .border(Color.red, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

#Preview {
    LoginView()
}
