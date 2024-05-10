import SwiftUI

struct RecordsHomeContent: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var router: Router
    @State private var documentFilterType: DocumentType?
    @State private var searchText: String = ""
    @State private var showAddDocumentTray = false
    
    var filteredDocuments: [Document] {
        let orderedDocuments: [Document] = viewModel.documents.sorted(by: {
                convertToDate(dateString: $0.date)!.compare(convertToDate(dateString: $1.date)!) == .orderedDescending
        })
        
        // Assess if there is a type filter.
        guard documentFilterType != nil else {
            return orderedDocuments
        }
        
        // Apply filter.
        let typeFiltered = orderedDocuments.filter { document in
            document.type == documentFilterType
        }
        
        return typeFiltered
    }
    
    var body: some View {
        VStack {
//            Spacer()
            HStack {
                RecordTypeTile(text: "All", image: documentFilterType == nil ? Image("home_white") : Image("home"), isSelected: documentFilterType == nil)
                    .onTapGesture {
                        documentFilterType = nil
                    }
                Spacer()
                RecordTypeTile(text: DocumentType.imaging.getName(), image: DocumentType.imaging.getImage(isSelected: documentFilterType == DocumentType.imaging), isSelected: documentFilterType == DocumentType.imaging)
                    .onTapGesture {
                        documentFilterType = DocumentType.imaging
                    }
                Spacer()
                RecordTypeTile(text: DocumentType.pathology.getName(), image: DocumentType.pathology.getImage(isSelected: documentFilterType == DocumentType.pathology), isSelected: documentFilterType == DocumentType.pathology)
                    .onTapGesture {
                        documentFilterType = DocumentType.pathology
                    }
                Spacer()
                RecordTypeTile(text: DocumentType.letter.getName(), image: DocumentType.letter.getImage(isSelected: documentFilterType == DocumentType.letter), isSelected: documentFilterType == DocumentType.letter)
                    .onTapGesture {
                        documentFilterType = DocumentType.letter
                    }
            }
            .padding([.bottom], 5)
            .padding([.top], 20)
            Button {
                if (viewModel.latestThreadId == "No thread currently assigned") {
                    Task {
                        await viewModel.generateNewThread()
                    }
                }
                showAddDocumentTray.toggle()
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
                    //                            .stroke(AppColours.maroon, lineWidth: 1)
                )
                .sheet(isPresented: $showAddDocumentTray) {
                    AddDocumentTray()
                        .presentationDetents([.medium])
                }
            }
            .padding([.bottom], 5)
//            Divider()
//                .padding([.bottom], 5)
//            HStack(spacing: 14) {
//                Image("search")
//                    .resizable()
//                    .frame(width: 18.0, height: 18.0)
//                TextField("Search documents", text: $searchText)
//            }
//            .padding(EdgeInsets(top: 22, leading: 18, bottom: 22, trailing: 18))
//            .background(Color(.white))
//            .cornerRadius(6)
//            .padding(.bottom, 10)
//            HStack {
//                Text("Recent")
//                Spacer()
//                HStack(spacing: 12) {
//                    Text("See all")
//                    Image("forward_button")
//                        .resizable()
//                        .frame(width: 4, height: 9)
//                }
//            }
//            .font(Font.callout.bold())
//            .padding(.bottom, 8)
            if filteredDocuments.count == 0 {
                    Text("*No uploaded documents*")
                        .font(.caption)
                        .foregroundColor(AppColours.maroon)
                        .padding(.vertical, 40)
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(filteredDocuments) { document in
                        NavigationLink(value: RecordsNavDestination.documentDetail(document: document)) {
                            DocumentListTile(document: document)
                        }
                    }
                    .animation(.default, value: filteredDocuments)
                }
            }
            Spacer()
        }
        .foregroundColor(AppColours.maroon)
        .padding([.horizontal], 20)
    }
}

//#Preview {
//    BaseView(BaseViewType.documents)
//        .environmentObject(MessageViewModel(userId: "1"))
//}
