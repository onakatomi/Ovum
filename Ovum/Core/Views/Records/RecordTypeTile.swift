import SwiftUI

enum RecordType {
    case all
    case imaging
    case pathology
    case letters
    
    func getImage(isSelected: Bool) -> Image {
        switch self {
        case .all:
            return isSelected ? Image("home_white"): Image("home")
        case .imaging:
            return isSelected ? Image("imaging_white"): Image("imaging")
        case .pathology:
            return isSelected ? Image("drop_white"): Image("drop")
        case .letters:
            return isSelected ? Image("records_white"): Image("records")
        }
    }    
    
    func getName() -> String {
        switch self {
        case .all:
            return "All"
        case .imaging:
            return "Imaging"
        case .pathology:
            return "Pathology"
        case .letters:
            return "Letters"
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .all:
            return Color(.clear)
        case .imaging:
            return Color(red: 0.7, green: 0.45, blue: 0.25)
        case .pathology:
            return AppColours.maroon
        case .letters:
            return Color(red: 0.7, green: 0.45, blue: 0.25)
        }
    }
}

struct RecordTypeTile: View {
    let recordType: RecordType
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            recordType.getImage(isSelected: isSelected)
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
            Text(recordType.getName())
                .font(Font.callout.weight(.semibold))
                .foregroundColor(AppColours.maroon)
        }
    }
}

//#Preview {
//    ContentView(selectedTab: .records)
//        .environment(MessageViewModel())
//}
