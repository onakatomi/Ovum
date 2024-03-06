import SwiftUI

struct RecordsHomeContent: View {
    @Environment(MessageViewModel.self) var viewModel
    @State private var selectedType: Int = 0
    @State private var searchText: String = ""
    
    var filteredDocuments: [Document] {
        if (searchText == "") {
            viewModel.documents
        } else {
            viewModel.documents.filter { document in
                document.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                RecordTypeTile(recordType: RecordType.all, isSelected: selectedType == 0 ? true : false)
                    .onTapGesture {
                        selectedType = 0
                    }
                Spacer()
                RecordTypeTile(recordType: RecordType.imaging, isSelected: selectedType == 1 ? true : false)
                    .onTapGesture {
                        selectedType = 1
                    }
                Spacer()
                RecordTypeTile(recordType: RecordType.pathology, isSelected: selectedType == 2 ? true : false)
                    .onTapGesture {
                        selectedType = 2
                    }
                Spacer()
                RecordTypeTile(recordType: RecordType.letters, isSelected: selectedType == 3 ? true : false)
                    .onTapGesture {
                        selectedType = 3
                    }
            }
                .padding([.bottom], 24)
                .padding([.top], 35)
            Button {
                print("add doc")
            } label: {
                HStack(spacing: 14) {
                    Image("add_button")
                    Text("Add a document")
                }
                    .frame(maxWidth: .infinity)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(red: 0.86, green: 0.84, blue: 0.98))
//                            .stroke(Color(red: 0.4, green: 0.16, blue: 0.06), lineWidth: 1)
                    )
            }
                .padding([.bottom], 24)
            Divider()
                .padding([.bottom], 24)
            HStack(spacing: 14) {
                    Image("search")
                        .resizable()
                        .frame(width: 18.0, height: 18.0)
                    TextField("Search documents", text: $searchText)
            }
                .padding(EdgeInsets(top: 22, leading: 18, bottom: 22, trailing: 18))
                .background(Color(.white))
                .cornerRadius(6)
                .padding(.bottom, 24)
            HStack {
                Text("Recent")
                Spacer()
                HStack(spacing: 12) {
                    Text("See all")
                    Image("forward_button")
                        .resizable()
                        .frame(width: 4, height: 9)
                }
            }
                .font(Font.callout.bold())
                .padding(.bottom, 8)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredDocuments) { document in
                        NavigationLink {
                            ChatHistory()
                        } label: {
                            DocumentListTile(document: document)
                        }
                    }
                    .animation(.default, value: filteredDocuments)
                }
            }
        }
        .foregroundColor(Color(red: 0.4, green: 0.16, blue: 0.06))
        .padding([.horizontal], 20)
    }
}

#Preview {
    RecordsHomeContent()
        .environment(MessageViewModel())
}
