import SwiftUI

struct MedicationTile: View {
    let medication: Medication
    
    var body: some View {
        VStack {
            HStack {
                Text(medication.name)
                Image("edit")
            }
            Divider()
            HStack {
                Image("pill")
                    .resizable()
                    .frame(width: 11, height: 11)
                Text("\(medication.form.rawValue) · \(medication.strength)")
            }
            HStack {
                Image("calendar")
                    .resizable()
                    .frame(width: 11, height: 11)
                if (medication.type == .ongoing) {
                    Text("\(medication.form.rawValue) · \(medication.strength)")
                } else {
                    Text("Reported on \(medication.)")
                }
            }
        }
    }
}

#Preview {
    MedicationTile(medication: Medication(type: .ongoing, name: "Panadol", form: .Cream, strength: "500 mg", frequency: .Daily))
}
