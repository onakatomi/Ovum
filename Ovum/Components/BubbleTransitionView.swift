import SwiftUI

struct BubbleTransitionView: View {
    @State var isVisible: Bool = false

    var body: some View {
        VStack {
            ZStack {
                if isVisible {
                    HStack(spacing: 13) {
                        Image("level_medium")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text("Need me to explain anything about this document? Tap me to chat!")
                            .font(Font.caption)
                            .foregroundColor(.white)
                    }
                    .padding(15)
                    .background {
                        MapOnboardingBubbleShape().fill(AppColours.maroon)
                    }
                    .transition(.opacity.combined(with: .scale).animation(.spring(response: 0.25, dampingFraction: 0.7)))
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isVisible = true
                }
            }
//            .frame(width: 200, height: 100)
//            .padding(.bottom, 50)

//            Button(isVisible ? "Hide" : "Show") {
//                isVisible.toggle()
//            }
        }
    }
}

#Preview {
    BubbleTransitionView()
}
