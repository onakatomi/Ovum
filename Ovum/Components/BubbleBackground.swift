import SwiftUI

struct DrawBubbleView: View {
    @State var drawFraction: CGFloat = 0

    var body: some View {
        VStack {
            MapOnboardingBubbleShape()
                .trim(from: 0, to: drawFraction)
                .stroke(.gray, lineWidth: 3)
                .animation(.spring(), value: drawFraction)
                .frame(width: 150, height: 100)
                .padding(.bottom, 50)

            Button(drawFraction > 0.0 ? "Hide" : "Show") {
                drawFraction = drawFraction > 0.0 ? 0.0 : 1.0
            }
            .tint(Color.gray)
        }
    }
}
//
//struct Cloud1View_Previews: PreviewProvider {
//    static var previews: some View {
//        Cloud1Shape()
//            .fill(.gray)
//            .previewingShape()
//    }
//}
