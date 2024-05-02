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
                    .font(.custom(AppFonts.haasGrot, size: 64))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Pilot")
                    .font(.custom(AppFonts.testDomaine, size: 23))
                    .italic()
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    SplashScreen()
}
