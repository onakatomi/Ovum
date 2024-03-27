import SwiftUI

enum DocumentType: String, Codable, CaseIterable, Identifiable, CustomStringConvertible {
    case imaging = "Imaging"
    case pathology = "Pathology"
    case letter = "Letter"
    //            return isSelected ? Image("home_white"): Image("home")
    
    func getImage(isSelected: Bool) -> Image {
        switch self {
        case .imaging:
            return isSelected ? Image("imaging_white"): Image("imaging")
        case .pathology:
            return isSelected ? Image("drop_white"): Image("drop")
        case .letter:
            return isSelected ? Image("records_white"): Image("records")
        }
    }    
    
    func getName() -> String {
        switch self {
        case .imaging:
            return "Imaging"
        case .pathology:
            return "Pathology"
        case .letter:
            return "Letters"
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .imaging:
            return AppColours.mint
        case .pathology:
            return AppColours.maroon
        case .letter:
            return AppColours.darkBeige
        }
    }
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .imaging:
            return "Imaging"
        case .pathology:
            return "Pathology"
        case .letter:
            return "Letter"
        }
    }
}

struct RecordTypeTile: View {
    let text: String
    let image: Image
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
//            recordType.getImage(isSelected: isSelected)
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 28)
                .padding(30)
                .background(
                  RoundedRectangle(cornerRadius: 6)
                    .fill(isSelected ? AppColours.maroon : .clear)
                    .stroke(AppColours.maroon, lineWidth: 1)
                    .frame(height: 80)
                )
                .padding(.bottom, 0)
//            Text(recordType.getName())
            Text(text)
                .font(Font.callout.weight(.semibold))
                .foregroundColor(AppColours.maroon)
        }
            .contentShape(Rectangle())
    }
}

//#Preview {
//    ContentView(selectedTab: .records)
//        .environmentObject(MessageViewModel(userId: "1"))
//}
