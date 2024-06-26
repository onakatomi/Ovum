import SwiftUI

struct Rating: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let session: String
    var handler: (() -> Void)
    @State var score: Int = 0
    
    var body: some View {
        ZStack {
            Color(AppColours.brown)
                .ignoresSafeArea()
            VStack {
                Text("How would you rate this chat?")
                    .font(Font.custom(AppFonts.haasGrot, size: 20))
    //                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .kerning(0.32)
                    .foregroundColor(AppColours.buttonBrown)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack(spacing: 10) {
                    ForEach(0..<5) { index in
                        Image(systemName: imageName(index: index))
                            .resizable()
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                score = index + 1
                            }
                    }
                }
                .foregroundColor(.yellow)
                Spacer()
                HStack {
                    Button {
                        handler()
                    } label: {
                        Text("Skip")
                            .opacity(0.4)
                    }
                    Spacer()
                    Button {
                        Task {
                            await viewModel.assignRating(sessionId: session, rating: score, userId: authViewModel.currentUser!.id)
                        }
                        handler()
                    } label: {
                        Text("Submit")
                    }
                    .disabled(score == 0)
                }
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 30)
        }
    }
    
    func imageName(index: Int) -> String {
        // Version A
        if index >= self.score {
            return "star"
        } else {
            return "star.fill"
        }
    }
}

struct RatingsView_Previews: PreviewProvider {
    static var previews: some View {
        Rating(session: "1") {
            print("TODO")
        }
    }
}
