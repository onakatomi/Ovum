import SwiftUI

struct AboutOvumView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("back_button")
                }
                Spacer()
            }
            .padding(.bottom, 18)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            
            VStack(alignment: .leading, spacing: 9) {
                Text("About Ovum")
                    .font(.custom(AppFonts.haasGrot, size: 42))
                    .fontWeight(.bold)
                    .foregroundColor(AppColours.darkBrown)
                Text("How you’re helping womankind")
                    .font(.custom(AppFonts.testDomaine, size: 22))
            }
            .padding(.bottom, 16)
            Divider()
                .background(AppColours.maroon)
                .padding(.bottom, 16)
            
            ScrollView() {
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("The first personal health assistant powered by A.I to support women.")
                        .font(.custom(AppFonts.testDomaine, size: 24))
                        .foregroundColor(AppColours.darkBrown)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("At Ovum we believe women deserve knowledge, control, and a lifespan approach to their healthcare.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                    
                    Text("Our Mission is to: Empower women on their health journey.")
                        .font(.custom(AppFonts.testDomaine, size: 24))
                        .foregroundColor(AppColours.darkBrown)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("At Ovum, we recognise the unique challenges women face throughout their lives, especially those with chronic illnesses. Our mission is to provide a platform where women can understand, manage, and take control of their health, guided by intelligent, personalised insights.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                    
                    Text("The reality for women")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("At Ovum, we recognise the unique challenges women face throughout their lives, especially those with chronic illnesses. Our mission is to provide a platform where women can understand, manage, and take control of their health, guided by intelligent, personalised insights.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                    
                    Text("The emotional toll")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("The repeated experience of not being taken seriously, or having symptoms brushed off as 'just emotional,' can lead to anxiety, distrust, and avoidance of medical care.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                    
                    Text("Navigating Dr.Google")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("In desperation, many women turn to the internet, sifting through endless pages, trying to self-diagnose. But without guidance, this can lead to misinformation and heightened fears.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                    
                    Text("The cost of silence")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("For too long, women's health issues like endometriosis, PCOS, and postpartum depression have been stigmatised, making women suffer in silence.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                    
                    Text("The data gap")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("The lack of extensive women-specific health data means that many treatments and protocols are not tailored for women, leading to sub-optimal care.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                    
                    Text("The Ovum solution")
                        .font(.custom(AppFonts.testDomaine, size: 24))
                        .foregroundColor(AppColours.darkBrown)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    Text("Ovum confronts the healthcare challenges faced by women with an AI-powered personal health assistant, designed to provide targeted, empathetic support.\n\nAddressing misdiagnosis and neglected symptoms, Ovum offers a nuanced understanding of women’s health issues. By leveraging real-patient data and narratives, Ovum ensures individual health concerns are met with personalised guidance and care.\n\nThis technology stands as an advocate for women, transforming interactions with healthcare systems into a supportive, empowering experience.\n\nWith Ovum, the journey to wellness is clearer—our digital ally in navigating the complexities of women's health.")
                        .font(.custom(AppFonts.haasGrot, size: 17))
                        .foregroundColor(AppColours.darkBrown)
                        .lineSpacing(4)
                }
            }
        }
        .padding(.horizontal, 20)
        .background {
            AppColours.brown
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AboutOvumView()
}
