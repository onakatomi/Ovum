import SwiftUI

enum BodyPart: String, Codable {
    case head
    case breast
    case abdomen
    case pelvic
    case arm
    case leg
    case none
    
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
        case .arm:
            return (-(0.22*imageSize.height/2), 0.05*imageSize.height/2)
        case .leg:
            return (-(0.50*imageSize.height/2), 0.37*imageSize.height/2)
        case .none:
            return (-0.65*imageSize.height/2, -(0.33*imageSize.height/2))
        }
    }
}

enum Status: CaseIterable {
    case investigate
    case monitor
    case treated
    case none
    
    func getImageName() -> String {
        switch self {
        case .investigate:
            return "status_cross_red"
        case .monitor:
            return "status_cross_yellow"
        case .treated:
            return "status_cross_green"
        case .none:
            return "status_cross_blue"
        }
    }
}

func mapSeveritytoStatus(severity: String) -> Status {
    if (severity == "severe") {
        return .investigate
    } else if (severity == "mild") {
        return .monitor
    } else if (severity == "minor") {
        return .treated
    } else {
        return .none
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
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var router: Router
    @State private var sliderValue: Double = 0.0
    @State private var isEditing = false
    @State var imageSize: CGSize = .zero
    @State private var showSymptomTray = false
    @State private var currentlySelectedIndex = 0
    
    var orderedChatSessions: [ChatSession] {
        viewModel.chatSessions.sorted(by: {
            convertToDate(dateString: $0.date)!.compare(convertToDate(dateString: $1.date)!) == .orderedAscending
        })
    }
    
    var body: some View {
        VStack {
            if (healthKitManager.sleep != nil && healthKitManager.menstrualFlow != nil) {
                HStack {
                    Text("**Sleep Time** · \(healthKitManager.sleep!)")
                    Spacer()
                    Text("**Flow** · \(healthKitManager.menstrualFlow!)")
                }
            }
            
            ZStack {
                Image("Figure")
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 25)
                    .background(rectReader()) // Get displayed image size.
                if orderedChatSessions.count > 0 {
                    ZStack {
                        ForEach(Array(orderedChatSessions[Int(sliderValue)].bodyParts.enumerated()), id: \.offset) { index, bodyPart in
                            Image.getBodyPartImage(region: bodyPart, status: mapSeveritytoStatus(severity: orderedChatSessions[Int(sliderValue)].severities[index]), imageSize: self.imageSize)
                                .onTapGesture {
                                    currentlySelectedIndex = index
                                    showSymptomTray = true
                                }
                            
                                .sheet(isPresented: $showSymptomTray) {
                                    SymptomTray(
                                        index: currentlySelectedIndex,
                                        chatSession: orderedChatSessions[Int(sliderValue)]
                                        
                                    ) {
                                        showSymptomTray = false
                                        router.navigateToRoot(within: .chat)
                                        router.navigateWithinChat(to: .chatHistoryDetail(session: orderedChatSessions[Int(sliderValue)]))
                                    }
                                    .presentationDetents([.medium])
                                }
                        }
                    }
                }
            }
            if (viewModel.chatSessions.count >= 2) {
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
            }
            if orderedChatSessions.count > 0 {
                Text(stripDateString(dateString: orderedChatSessions[Int(sliderValue)].date, format: .elegant))
                    .foregroundColor(AppColours.maroon)
            } else {
                Text("*Record your first chat session to visualise your symptoms*")
                    .font(.caption)
                    .foregroundColor(AppColours.maroon)
            }
            Spacer()
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



#Preview {
    ContentView()
//    OverviewHomeContent()
//        .environmentObject(Router())
//        .environmentObject(HealthKitManager())
//        .environmentObject(MessageViewModel(userId: "1", authViewModelPassedIn: AuthViewModel()))
}
