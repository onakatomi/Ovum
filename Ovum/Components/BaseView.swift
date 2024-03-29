import SwiftUI

enum BaseViewType {
    case overview
    case chat
    case documents
}

func getImage(type: BaseViewType) -> Image {
    switch type {
    case .overview:
        return Image("overview")
    case .chat:
        return Image("chat")
    case .documents:
        return Image("documents")
    }
}
func getHeaderImage(type: BaseViewType) -> Image {
    switch type {
    case .overview:
        return Image("level_high")
    case .chat:
        return Image("level_medium")
    case .documents:
        return Image("level_low")
    }
}

func getHeader(type: BaseViewType) -> Header {
    switch (type) {
    case BaseViewType.chat:
        Header(firstLine: "Chat with", secondLine: "Ovum", colour: Color(.white), font: Font.custom(AppFonts.haasGrot, size: 42))
    case BaseViewType.overview:
        Header(firstLine: "Your health", secondLine: "overview", colour: Color(.white), font: Font.custom(AppFonts.haasGrot, size: 42))
    case BaseViewType.documents:
        Header(firstLine: "Medical", secondLine: "Records", colour: Color(.white), font: Font.custom(AppFonts.haasGrot, size: 42))
    }
}

struct BaseView: View {
    
    let type: BaseViewType
    
    init(_ type: BaseViewType) {
        self.type = type // equivalent to free init
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
            ZStack(alignment: .top) {
                getImage(type: type)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 10, opaque: true)
                VStack(spacing: 0) {
                    NavigationLink (destination: Menu().toolbar(.hidden, for: .tabBar)) { // Hide tabbar whilst in MenuScreen.
                        Image("menu_white")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 8)
                            .padding(.bottom, 18)
                    }
                    .navigationBarBackButtonHidden()
                    Divider()
                        .background(.white)
                        .padding(.bottom, 13)
                    HStack(alignment: .top) {
                        getHeader(type: type)
                        Spacer()
                    }
                }
                .padding([.top], 60)
                .padding([.horizontal], 20)
            }
            .background(Color.yellow)
            
            ZStack(alignment: .center) {
                Color(AppColours.brown)
                VStack {
                    switch (type) {
                    case BaseViewType.overview:
                        OverviewHomeContent()
                    case BaseViewType.chat:
                        ChatHomeContent()
                    case BaseViewType.documents:
                        RecordsHomeContent()
                    }
                }
            }
            .clipShape(
                .rect(
                    topLeadingRadius: 12,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 12
                )
            )
            .padding([.top], 220)
        }
        .ignoresSafeArea(.all, edges: Edge.Set(Edge.top))
    }
}

#Preview {
    BaseView(BaseViewType.overview)
        .environmentObject(MessageViewModel(userId: "1"))
}
