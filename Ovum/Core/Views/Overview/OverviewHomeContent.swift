import SwiftUI

enum BodyPart: String, Codable {
    case head
    case breast
    case abdomen
    case pelvic
    
    func getOffset(imageSize: CGSize) -> (widthOffset: CGFloat, heightOffset: CGFloat) {
        switch self {
        case .head:
            return (0, -(0.65*imageSize.height/2))
        case .breast:
            return ((0.20*imageSize.height/2), -(0.13*imageSize.height/2))
        case .abdomen:
            return (0, 0.20*imageSize.height/2)
        case .pelvic:
            return (0.05*imageSize.height/2, 0.5*imageSize.height/2)
        }
    }
}

enum Status: CaseIterable {
    case investigate
    case monitor
    case treated
    
    func getImageName() -> String {
        switch self {
        case .investigate:
            return "status_icon"
        case .monitor:
            return "status_icon"
        case .treated:
            return "status_icon"
        }
    }
}

extension Image {
    static func getBodyPartImage(region: BodyPart, status: Status, imageSize: CGSize) -> some View {
        return Image(status.getImageName())
            .resizable()
            .frame(width: 30, height: 30)
            .offset(x: region.getOffset(imageSize: imageSize).widthOffset, y: region.getOffset(imageSize: imageSize).heightOffset)
    }
}

struct OverviewHomeContent: View {
    @StateObject var healthKitManager = HealthKitManager.shared
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var router: Router
    @State private var sliderValue: Double = 0.0
    @State private var isEditing = false
    @State var imageSize: CGSize = .zero // << or initial from NSImage
    @State private var showSymptomTray = false
    @State private var currentlySelectedIndex = 0
    
    var orderedChatSessions: [ChatSession] {
        viewModel.chatSessions.sorted(by: {
            convertToDate(dateString: $0.date)!.compare(convertToDate(dateString: $1.date)!) == .orderedAscending
        })
    }
    
    var body: some View {
        VStack {
//            Text("Today's steps: \(healthKitManager.stepCountToday)")
            HStack {
                Text("**Sleep** · Regular")
                Spacer()
                Text("**Activity** · Regular")
            }
            ZStack {
                Image("Figure")
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 25)
                    .background(rectReader()) // Get displayed image size.
                ZStack {
                    ForEach(Array(orderedChatSessions[Int(sliderValue)].bodyParts.enumerated()), id: \.offset) { index, bodyPart in
                        Image.getBodyPartImage(region: bodyPart, status: Status.allCases.randomElement()!, imageSize: self.imageSize)
                            .onTapGesture {
                                currentlySelectedIndex = index
                                showSymptomTray = true
                            }
                        
                            .sheet(isPresented: $showSymptomTray) {
                                SymptomTray(correspondingSymptom: orderedChatSessions[Int(sliderValue)].symptoms[currentlySelectedIndex], chatSession: orderedChatSessions[Int(sliderValue)]) {
                                    showSymptomTray = false
                                    router.navigateToRoot(within: .chat)
                                    router.navigateWithinChat(to: .chatHistoryDetail(session: orderedChatSessions[Int(sliderValue)]))
                                }
                                    .presentationDetents([.medium])
                            }
                    }
                }
            }
            Slider(
                value: $sliderValue,
                in: 0...(Double(viewModel.chatSessions.count) - 1),
                step: 1,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            HStack {
                Text(stripDateString(dateString: orderedChatSessions[0].date, format: .basic))
                Spacer()
                Text("Today")
            }
            .fontWeight(.bold)
                .foregroundColor(AppColours.maroon)
            if orderedChatSessions.count > 0 {
                Text(stripDateString(dateString: orderedChatSessions[Int(sliderValue)].date, format: .elegant))
                    .foregroundColor(AppColours.maroon)
//                    .fontWeight(!isEditing ? .medium : .bold)
//                    .italic()
            }
//            HStack {
//                ForEach(orderedChatSessions[Int(sliderValue)].bodyParts, id: \.self) { bodyPart in
//                    Text(String(describing: bodyPart))
//                }
//            }
            Spacer()
//            TransparentButton(text: "View Medications", colour: AppColours.maroon) {
//                print("meds")
//            }
            
//            VStack {
//                ForEach(orderedChatSessions) { session in
//                    HStack {
//                        ForEach(session.bodyParts, id: \.self) { bodyPart in
//                            Text(bodyPart)
//                        }
//                    }
//                }
//            }
        }
        .padding(.all, 20)
    }
    
    private func rectReader() -> some View {
        return GeometryReader { (geometry) -> Color in
            let imageSize = geometry.size
            DispatchQueue.main.async {
//                print(">> \(imageSize)") // use image actual size in your calculations
                self.imageSize = imageSize
            }
            return .clear
        }
    }
}



//#Preview {
//    OverviewHomeContent()
//        .environmentObject(MessageViewModel(userId: "1"))
//}
