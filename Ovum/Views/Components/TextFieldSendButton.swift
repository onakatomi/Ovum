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
                        .foregroundColor(AppColours.maroon)
                }
            )
            
        }
    }
}
