import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            AppColours.darkBrown
            VStack(spacing: 0) {
                Image("ovum_icon_white")
                    .resizable()
                    .frame(width: 77.03857, height: 53.78031)
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                    Text("Ovum")
                        .font(.custom(AppFonts.haasGrot, size: 64))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                    Text("Beta")
                        .font(Font.custom(AppFonts.testDomaine, size: 10))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 1)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color(red: 0.81, green: 0.78, blue: 0.96))
                    )
                    .foregroundColor(Color(red: 0.49, green: 0.27, blue: 0.18))
                }
                Text("Pilot")
                    .font(.custom(AppFonts.testDomaine, size: 23))
                    .italic()
                    .foregroundColor(.white)
            }
        }
//        .uxcamTagScreenName("SplashScreen")
    }
}

#Preview {
    SplashScreen()
}
