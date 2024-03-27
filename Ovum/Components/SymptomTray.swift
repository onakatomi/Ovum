import SwiftUI

struct SymptomTray: View {
    let correspondingSymptom: String
    let chatSession: ChatSession
    var handler: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Image("status_monitor")
                    VStack {
                        Text("**Symptom Reported**")
                            .font(.subheadline)
                        Text(chatSession.date)
                            .font(.subheadline)
                    }
                }
                Spacer()
                Button {
                    handler()
                } label: {
                    Text("View Chat")
                        .font(.subheadline)
                        .padding(10)
                        .background(AppColours.indigo)
                        .cornerRadius(6)
                }
            }
            Divider()
                .background(AppColours.maroon)
                .padding(.vertical, 16)
            Text(correspondingSymptom.capitalized)
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(AppColours.darkBrown)
            Divider()
                .background(AppColours.maroon)
                .padding(.vertical, 16)
            if (chatSession.summary != nil)  {
                VStack(alignment: .leading) {
                    Text("**Chat Summary**")
                        .padding(.vertical, 10)
                    ScrollView {
                        Text(chatSession.summary!)                        
                    }
                }
                .foregroundColor(AppColours.darkBrown)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
}

#Preview {
    OverviewHomeContent()
        .environmentObject(MessageViewModel(userId: "1"))
}
