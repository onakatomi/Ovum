import SwiftUI

struct DocumentListTile: View {
    let document: Document
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(red: 0.4, green: 0.16, blue: 0.06))
                .padding(.bottom, 24)
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.4, green: 0.16, blue: 0.06))
                        .frame(width: 40, height: 40)
                    document.type.getImage(isSelected: true)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 22)
                }
                Spacer()
                    .frame(width: 24)
                HStack {
                    Text(document.title)
                        .font(Font.headline.weight(.bold))
                    Text("·")
                    Text(document.date)
                        .font(Font.headline.weight(.light))
                }
                .foregroundStyle(Color(red: 0.4, green: 0.16, blue: 0.06))
                Spacer()
                Image("forward_arrow")
            }
            .padding(.bottom, 24)
        }
    }
}

#Preview {
    DocumentListTile(document: Document(title: "Hormones", date: "17/2/22", type: RecordType.pathology))
}
