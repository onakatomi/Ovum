import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    var handler: () async -> Void
    
    func body(content: Content) -> some View {
        HStack {
            content
            Button(
                action: {
                    Task {
                        await handler()
                        self.text = ""
                    }
                },
                label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(Color(red: 0.4, green: 0.16, blue: 0.06))
                }
            )
            
        }
    }
}
