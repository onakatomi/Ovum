import SwiftUI

struct MessageInputField: View {
    @Binding var textInput: String
    var handler: () async -> Void
    
    var body: some View {
        TextField("", text: $textInput)
            .frame(height: 40)
            .modifier(TextFieldClearButton(text: $textInput, handler: handler))
            .multilineTextAlignment(.leading)
            .padding(.horizontal, 30)
            .background(
              RoundedRectangle(cornerRadius: 50)
                .fill(.white)
            )
    }
}
