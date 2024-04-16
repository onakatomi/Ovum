import SwiftUI

struct WarningView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                        Text("I’ve been trained on a large body of medical data, including books, articles, and research papers. From there, I learned to recognise patterns and make predictions based on the language used in the text.\n\nSo, when you ask me a question about medicine, I use my understanding of the language and concepts related to the subject I’ve learned from to give you an answer.\n\n It’s important to note that while I have access to a vast amount of information related to medicine, I am not a substitute for medical advice from a qualified healthcare professional. It’s always important to consult with a healthcare provider before making any medical decisions.\n\nLong story short: I’m basically a walking encyclopaedia with no medical degree. What I can do is help you track your symptoms and answer questions so you can have a better understanding of your health.\n\nOVUM is designed to better equip you to monitor your own health and give you more information to work with your doctor.")
                            .font(.custom(AppFonts.haasGrot, size: 16))
                            .kerning(0.32)
                            .foregroundColor(AppColours.lightYellow)
                            .lineSpacing(4)
                        Button {
                            
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
