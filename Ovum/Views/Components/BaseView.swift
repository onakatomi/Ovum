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

func getHeader(type: BaseViewType) -> Header {
    switch (type) {
    case BaseViewType.chat:
        Header(firstLine: "Chat with", secondLine: "Ovum", colour: Color(.white))
    case BaseViewType.overview:
         Header(firstLine: "Your health", secondLine: "overview", colour: Color(.white))
    case BaseViewType.documents:
         Header(firstLine: "Medical", secondLine: "Records", colour: Color(.white))
    }
}

func getContent(type: BaseViewType) -> ChatHomeContent {
    switch (type) {
    case BaseViewType.chat:
        ChatHomeContent()
    case BaseViewType.overview:
        ChatHomeContent()
    case BaseViewType.documents:
        ChatHomeContent()
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
                    VStack {
                        Image(systemName: "filemenu.and.cursorarrow")
                            .imageScale(.large)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.trailing, 8)
                            .foregroundColor(.white)
                        Divider()
                            .background(.white)
                        HStack(alignment: .top) {
                            getHeader(type: type)
                            
                            Spacer()
                        Image("green_circle")
                        }
                    }
                    .padding([.top], 60)
                    .padding([.horizontal], 20)
                }
                .background(Color.yellow)
                
                ZStack(alignment: .top) {
                    Color(Color(red: 0.98, green: 0.96, blue: 0.92))
                    VStack {
                        getContent(type: type)
                    }
                }
                .cornerRadius(12)
                .padding([.top], 220)
            }
            .ignoresSafeArea()
        }
}

#Preview {
    BaseView(BaseViewType.chat)
}
