import SwiftUI

struct SendMessageField: View {
    enum FocusField: Hashable {
      case field
    }
    
    @Binding var textInput: String
    var isDisabled: Bool = false
    var handler: (() async -> Void)? // Optional function argument.
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        HStack(spacing: 0) {
            TextField(isDisabled ? "*Awaiting Ovum...*" : "", text: $textInput)
                    .focused($focusedField, equals: .field)
                    .onAppear {
                      self.focusedField = .field
                    }
                    .disabled(isDisabled)
                    .multilineTextAlignment(.leading)
                    .onSubmit {
                        Task {
                            if (textInput != "") {
                                if let handler {
                                    await handler()
                                }
                            }
                        }
                    }
                Spacer()
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .frame(width: 37.0, height: 37.0)
                    .foregroundColor(AppColours.maroon)
            }
            .padding(EdgeInsets(top: 7, leading: 25, bottom: 7, trailing: 9))
            .background(Color.white)
            .cornerRadius(50)
    }
}

#Preview {
    ContentView()
}
