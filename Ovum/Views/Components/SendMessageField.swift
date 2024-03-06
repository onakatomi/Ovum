import SwiftUI

struct SendMessageField: View {
    @Binding var textInput: String
    var handler: (() async -> Void)? // Optional function argument.
    var isDisabled: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
                TextField("", text: $textInput)
                .disabled(isDisabled)
                    .multilineTextAlignment(.leading)
                    .onSubmit {
                        Task {
                            if let handler {
                                await handler()
                            }
                        }
                    }
                Spacer()
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 37.0, height: 37.0)
                    .foregroundColor(Color(red: 0.4, green: 0.16, blue: 0.06))
            }
            .padding(EdgeInsets(top: 7, leading: 25, bottom: 7, trailing: 9))
            .background(Color(.white))
            .cornerRadius(50)
    }
}

#Preview {
    ContentView()
}
