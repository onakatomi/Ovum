import SwiftUI

struct WarningView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            Color(AppColours.darkBrown)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Text("Warning")
                        .foregroundColor(Color(.white))
                        .fontWeight(.semibold)
                    //                        .font(.largeTitle)
                        .font(.system(size: 50))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Image("warning")
                        .resizable()
                        .frame(width: 54, height: 54)
                }
                ThickDivider(color: Color(.white), width: 1, padding: 0)
                    .padding(.bottom, 15)
                VStack {
                    Text("A quick note on AI")
                        .fontWeight(.light)
                        .foregroundColor(Color(.white))
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.bottom, 30)
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Use of Ovum AI and information made available through Ovum AI is provided for general information purposes only. It is not a substitute for obtaining professional medical advice, or for your own health professional’s health or medical advice. We do not provide clinical assessment, diagnosis, treatment or advice. You must seek professional medical advice in relation to your symptoms. You understand and agree that any information obtained through using Ovum AI is at your sole risk. Do not rely on output received from Ovum AI without independent fact-checking from a qualified medical or health care professional. If you are suffering from an emergency condition, call the emergency services number in your region (AU: Triple Zero (000)) and ask for an ambulance.\n\nYou agree that you will not rely on the use of Ovum AI or information received through Ovum AI (including symptom reports and summaries) as medical or health advice and must verify all information in consultation with a medical or health care professional. Always consult a qualified medical or health care professional if you have any questions regarding any medical issues.\n\nTo the extent permitted by law, we expressly disclaim and exclude all liability for any loss, damage, cost or expense suffered or incurred by you or any other party arising in connection with your reliance on Ovum AI or information generated through Ovum AI as medical or health advice.\n\nTo allow you to use certain features of Ovum, you may choose to (but you do not have) provide us with additional information, like height, weight, health symptoms, health tracking (your menstrual cycle, any data you choose to share through integration with Apple Health (optional)), past medical history, antenatal history, number of times you have seen a doctor, smoking and drinking history, diet (Voluntary Information).\n\nWe take reasonable precautions to ensure that we de-identify your information. You must not include in the Voluntary Information your full name, email address or other identifying information in any input in Ovum other than the account set up stage (this includes free text entry and document or photographic uploads), as it cannot be guaranteed that this information will be flagged as information which may identify you.")
                            .font(.custom(AppFonts.haasGrot, size: 16))
                            .kerning(0.32)
                            .foregroundColor(AppColours.lightYellow)
                            .lineSpacing(4)
                        Button {
                            openURL(URL(string: "https://www.ovum-ai.com.au/")!)
                        } label: {
                            Text("Learn more")
                                .foregroundColor(.white)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .underline()
                                .padding(.top, 10)
                        }
                    }
                    .padding(.trailing, 10)
                }
                .padding(.bottom, 30)
                
                Spacer()

                PurpleButton(image: "upload", text: "Next") {
                    Task {
                        authViewModel.currentUser?.warningAccepted = true
                    }
                }
                    .frame(width: UIScreen.main.bounds.width - 32)
            }
            .padding(.top, 30)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    WarningView()
        .environmentObject(AuthViewModel())
}
