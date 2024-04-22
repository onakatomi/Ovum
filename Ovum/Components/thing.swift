import SwiftUI

// Define the enum for fruit types
enum Fruit: String, CaseIterable {
    case apple = "Apple"
    case banana = "Banana"
    case orange = "Orange"
}

enum MedicationIntakeFrequency: String, CaseIterable, Codable, Hashable {
    case Daily = "Daily"
    case TwiceDaily = "Twice daily"
    case ThriceDaily = "Three times a day"
    case QwiceDaily = "Four times a day"
    case Weekly = "Once a week"
    case AsNeeded = "As needed"
}

// Define the object containing the fruit field
struct MyObject {
    var name: String
    var age: Int
    var fruit: Fruit
}

// Define the object containing the fruit field
struct MyMedication {
    var type: MedicationType
    var name: String
    var freq: MedicationIntakeFrequency
}

struct Thing: View {
    @State private var myObject = MyObject(name: "John", age: 30, fruit: .apple)
    @State private var medicationObject: MyMedication = MyMedication(type: .ongoing, name: "f", freq: MedicationIntakeFrequency.Daily)
    @State private var medicationObject2: Medication = Medication(type: .ongoing, name: "", frequency: .AsNeeded, dateRecorded: Date.now)

    var body: some View {
        VStack {
            Picker("Select a freq", selection: $medicationObject2.frequency) {
                ForEach(MedicationIntakeFrequency.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category as MedicationIntakeFrequency?)
                }
            }
            .padding()

            Text("Selected Fruit: \(medicationObject2.frequency!.rawValue)")
                .padding()
            
            Picker("Frequency", selection: $medicationObject.freq) {
                 ForEach(MedicationIntakeFrequency.allCases, id: \.self) { category in
                     Text(category.rawValue)
                 }
             }
             .padding(.vertical, 10)
             .frame(maxWidth: .infinity)
             .background(
                 RoundedRectangle(cornerRadius: 6)
                     .fill(.white)
                     .stroke(AppColours.darkBrown, lineWidth: 1)
             )

            Text("Selected freq: \(medicationObject.freq.rawValue)")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Thing()
    }
}
