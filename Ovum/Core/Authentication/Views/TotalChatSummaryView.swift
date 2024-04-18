import SwiftUI

struct TotalChatSummaryView: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var totalSummary = ""
    @State private var isFetching: Bool = false
    
    var orderedChatSessions: [ChatSession] {
        viewModel.chatSessions.sorted(by: {
            convertToDate(dateString: $0.date)!.compare(convertToDate(dateString: $1.date)!) == .orderedAscending
        })
    }
    
    var orderedChatSessionSummaries: [String] {
        viewModel.chatSessions.sorted(by: {
            convertToDate(dateString: $0.date)!.compare(convertToDate(dateString: $1.date)!) == .orderedAscending
        }).map {
            $0.summary!
        }
    }
    
    func getUniqueSymptoms(sessions: [ChatSession]) -> [String] {
        var symptomsSet = Set<String>()

        for session in orderedChatSessions {
            for symptom in session.symptoms {
                symptomsSet.insert(symptom)
            }
        }
        
        return Array(symptomsSet)
    }
    
    var body: some View {
        ZStack {
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
                    Text("Medical Summary")
                        .font(.custom(AppFonts.haasGrot, size: 37))
                        .fontWeight(.bold)
                        .foregroundColor(AppColours.darkBrown)
                    Text("Your recently logged symptoms")
                        .font(.custom(AppFonts.testDomaine, size: 22))
                }
                .padding(.bottom, 16)
                Divider()
                    .background(AppColours.maroon)
                    .padding(.bottom, 16)
                
                if (orderedChatSessions.count > 0) {
                    ScrollView() {
                        if (!isFetching) {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    Text("Reported From: ").fontWeight(.bold)  +
                                    Text(stripDateString(dateString: orderedChatSessions.first!.date, format: .noTime)) +
                                    Text(" to ") +
                                    Text(stripDateString(dateString: orderedChatSessions.last!.date, format: .noTime))
                                }
                                .font(Font.custom("Haas Grot Disp Trial", size: 16))
                                .kerning(0.32)
                                .foregroundColor(AppColours.darkBrown)
                                .multilineTextAlignment(.leading)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(getUniqueSymptoms(sessions: orderedChatSessions), id: \.self) { symptom in
                                        Text(symptom.capitalized)
                                            .font(Font.custom(AppFonts.testDomaine, size: 22))
                                            .kerning(0.32)
                                            .foregroundColor(Color(red: 0.3, green: 0.1, blue: 0.04))
                                    }
                                }
                                
                                Text(.init(totalSummary))
                            }
                        }
                    }
                    .opacity(isFetching ? 0.5 : 1.0)
                    .task {
                        do {
                            isFetching = true
                            totalSummary = try await viewModel.getTotalSummary(authorId: authViewModel.currentUser!.id, authorInfo: authViewModel.currentUser!.onboardingInfo!, summaries: orderedChatSessionSummaries)
                            isFetching = false
                        } catch {
                            totalSummary = "Failed to fetch site."
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .background {
                AppColours.brown
                    .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            
            if isFetching {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColours.maroon))
            }
        }
    }
}

#Preview {
    TotalChatSummaryView()
}
