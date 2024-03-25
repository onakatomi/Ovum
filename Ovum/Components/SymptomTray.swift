import SwiftUI

struct SymptomTray: View {
    let chatSession: ChatSession
    var handler: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack {
                    Image("status_monitor")
                    VStack {
                        Text("**Status**:")
                            .font(.subheadline)
                        Text("Monitor")
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
            if (chatSession.summary != nil)  {
                VStack {
                    Text("**Chat Summary**")
                    Text(chatSession.summary!)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
    }
}

#Preview {
    OverviewHomeContent()
        .environment(MessageViewModel())
}
