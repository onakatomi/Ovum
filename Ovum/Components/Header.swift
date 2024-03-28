import SwiftUI

struct Header: View {
    var firstLine: String
    var secondLine: String
    var colour: Color
    let font: Font
    var bolded: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(firstLine)
            Text(secondLine)
        }
        .font(font)
        .fontWeight(bolded ? .bold : .regular)
        .foregroundColor(colour)
    }
}

//#Preview {
//    Header(firstLine: "Chat with", secondLine: "Ovum", colour: Color(.black), font: )
//}
