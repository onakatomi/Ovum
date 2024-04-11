import SwiftUI

struct MedicationTile: View {
    @EnvironmentObject var router: Router
    let medication: Medication
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(medication.name)
                    .font(.custom(AppFonts.haasGrot, size: 16))
                    .foregroundColor(AppColours.buttonBrown)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    switch (medication.type) {
                    case .ongoing:
                        router.navigateWithinMedication(to: .ongoing)
                    case .shortTerm:
                        router.navigateWithinMedication(to: .shortTerm)
                    case .noLongerTaking:
                        router.navigateWithinMedication(to: .noLongerTaking)
                    }
                } label: {
                    Image("edit")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            Divider()
                .foregroundColor(AppColours.buttonBrown)
                .padding(.vertical, 5)
            
            HStack {
                Image("pill")
                    .resizable()
                    .frame(width: 11, height: 11)
                Text("\(medication.form?.rawValue ?? "Unspecified form") · \(medication.strength ?? "Unspecified strength")")
                    .font(.custom(AppFonts.haasGrot, size: 14))
                    .foregroundColor(AppColours.buttonBrown)
            }
            
            HStack {
                Image("calendar")
                    .resizable()
                    .frame(width: 11, height: 12)
                if (medication.type == .ongoing) {
                    Text("\(medication.frequency?.rawValue ?? "Unspecified frequency")")
                        .font(.custom(AppFonts.haasGrot, size: 14))
                        .foregroundColor(AppColours.buttonBrown)
                } else if (medication.type == .shortTerm) {
                    Text((medication.courseEnd == nil || medication.howLongTakingFor == nil) ? "Unspecified" : "\(getStartDate(endDate: medication.courseEnd!, days: Int(medication.howLongTakingFor!)!)) - \(stripDateString(dateString: getDateAsString(date: medication.courseEnd!), format: .noTime))")
                        .font(.custom(AppFonts.haasGrot, size: 14))
                        .foregroundColor(AppColours.buttonBrown)
                } else if (medication.type == .noLongerTaking) {
                    Text((medication.courseEnd == nil || medication.howLongTookFor == nil) ? "Unspecified" : "\(getStartDate(endDate: medication.courseEnd!, days: Int(medication.howLongTookFor!)!)) - \(stripDateString(dateString: getDateAsString(date: medication.courseEnd!), format: .noTime))")
                        .font(.custom(AppFonts.haasGrot, size: 14))
                        .foregroundColor(AppColours.buttonBrown)
                }
            }
            
            if (medication.type != .ongoing) {
                HStack {
                    Image("medication_chat")
                        .resizable()
                        .frame(width: 11, height: 12)
                    Text("Reported on \(stripDateString(dateString: getDateAsString(date: medication.dateRecorded), format: .noTime))")
                        .font(.custom(AppFonts.haasGrot, size: 14))
                        .foregroundColor(AppColours.buttonBrown)
                }
            }
        }
        .padding(.all, 18)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(.white)
        )
    }
    
    func getStartDate(endDate: Date, days: Int) -> String {
        let newDate: Date = endDate.addingTimeInterval(-Double((86400*days)))
        let s1 = getDateAsString(date: newDate)
        let dateString = stripDateString(dateString: s1, format: .noTime)
        return dateString
    }
}

#Preview {
    ZStack {
        AppColours.brown
        VStack {
            MedicationTile(medication: Medication(type: .ongoing, name: "Panadol", form: .Cream, strength: "500 mg", frequency: .Daily, howLongTakingFor: String(describing: 10), courseEnd: Date.now, dateRecorded: Date.now))
            MedicationTile(medication: Medication(type: .noLongerTaking, name: "Panadol", form: .Cream, strength: "500 mg", frequency: .Daily, howLongTookFor: String(describing: 10), courseEnd: Date.now,  dateRecorded: Date.now))
        }
    }
    .environmentObject(Router())
}
