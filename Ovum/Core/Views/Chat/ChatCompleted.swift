import SwiftUI

struct ChatCompleted: View {
    @EnvironmentObject var router: Router
    var chatSession: ChatSession
    @State private var showRatingTray = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button {
                    withAnimation {
                        router.navigateWithinChat(to: .menu)
                    }
                } label: {
                    Image("menu_brown")
                }
                .navigationBarBackButtonHidden()
            }
            .padding(.bottom, 18)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            HStack(alignment: .top) {
                Header(firstLine: "Symptoms", secondLine: "Logged", colour: AppColours.maroon, font: .custom(AppFonts.haasGrot, size: 42))
                Spacer()
                Image("chat_completed")
                    .resizable()
                    .frame(width: 44.0, height: 44.0)
            }
            .padding(.bottom, 16)
            Text("Thank you. This information has been added to Ovum.")
                .font(.custom(AppFonts.testDomaine, size: 24))
                .foregroundColor(AppColours.darkBrown)
            Divider()
                .background(AppColours.maroon)
                .padding(.vertical, 16)
            ScrollView {
                VStack(alignment: .leading) {
                    Text("**Reported On**: \(stripDateString(dateString: chatSession.date, format: .elegant))")
                        .padding(.vertical, 8)
                    ForEach(chatSession.symptoms, id: \.self) { symptom in
                        Text(symptom == "none" ? "No symptoms reported" : symptom.capitalized)
                            .font(.custom(AppFonts.testDomaine, size: 24))
                            .padding(.vertical, 2)
                    }
                    Text("**Chat Summary:**")
                        .padding(.vertical, 8)
                    
                    Text(.init(chatSession.summary ?? "nothing"))
                        .font(.custom(AppFonts.haasGrot, size: 16))
                        .kerning(0.32)
                        .lineSpacing(7)
                }
            }
            .foregroundColor(AppColours.maroon)
            Spacer()
            PurpleButton(text: "Continue") {
                router.navigateToRoot(within: .chat)
            }
            .frame(width: UIScreen.main.bounds.width - 32)
            .padding(.bottom, 30)
        }
        .padding(.horizontal, 20)
        .background {
            AppColours.brown
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showRatingTray) {
            Rating(session: chatSession.id) {
                showRatingTray = false
            }
            .presentationDetents([.fraction(0.25)])
        }
    }
}

#Preview {
    ChatCompleted(chatSession: ChatSession(messages: chatData, bodyParts: [BodyPart.abdomen, BodyPart.head], symptoms: ["stomach ache", "fatigue"], severities: ["severe", "mild"], title: "Sample Chat Session #2", date: getDateAsString(date: Date.now), colour: AppColours.indigo, summary: "Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum.Thank you. This information has been added to Ovum."))
}
