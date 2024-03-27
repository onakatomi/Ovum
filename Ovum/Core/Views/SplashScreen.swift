import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            AppColours.darkBrown
            VStack(spacing: 0) {
                Image("ovum_icon_white")
                    .resizable()
                    .frame(width: 77.03857, height: 53.78031)
                Text("Ovum")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    SplashScreen()
}
