import SwiftUI

struct TagDocument: View {
    
    @Binding var documentTitle: String
    @Binding var documentType: DocumentType
    @FocusState.Binding var fieldIsFocused: Bool
    
    var body: some View {
        VStack(spacing: 20)  {
            InputView(text: $documentTitle, title: documentTitle, placeholder: "Enter document name", fieldIsFocused: $fieldIsFocused)
            HStack {
                Text("*Select a document type*")
                Spacer()
                Picker("Picker", selection: $documentType) {
                    ForEach(DocumentType.allCases) { option in
                        Text(String(describing: option))
                    }
                }
                .pickerStyle(.menu)
            }
            .padding(EdgeInsets(top: 7, leading: 25, bottom: 7, trailing: 9))
            .background(Color.white)
            .cornerRadius(10)

//            Text("Selected document type: \(documentType.description)")
        }
    }
}

//#Preview {
//    RecordsHomeContent()
//        .environmentObject(MessageViewModel(userId: "1"))
//}
