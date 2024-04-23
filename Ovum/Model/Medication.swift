import Foundation
import SwiftUI

enum StrengthOptions: String, CaseIterable, Codable, Hashable {
    case mg = "mg"
    case mcg = "mcg"
    case g = "g"
    case IU = "IU"
    case mL = "mL"
    case percent = "%"
}

enum ConsumptionLength: String, CaseIterable, Codable, Hashable {
    case days = "Days"
    case weeks = "Weeks"
    case months = "Months"
    case years = "Years"
}

enum MedicationType: String, CaseIterable, Codable, Hashable {
    case ongoing = "Ongoing"
    case shortTerm = "Short-term"
    case noLongerTaking = "No longer taking"
}

enum MedicationForm: String, CaseIterable, Codable, Hashable {
    case Capsule = "Capsule"
    case Cream = "Cream"
    case Device = "Device"
    case Drops = "Drops"
    case Foam = "Foam"
    case Gel = "Gel"
    case Inhaler = "Inhaler"
    case Injection = "Injection"
    case Liquid = "Liquid"
    case Patch = "Patch"
    case Powder = "Powder"
    case Spray = "Spray"
    case Suppository = "Suppository"
    case Tablet = "Tablet"
    case Topical = "Topical"
}

//enum MedicationIntakeFrequency: String, CaseIterable, Codable, Hashable {
//    case Daily = "Daily"
//    case MultipleTimesDaily = "Multiple times daily"
//    case Weekly = "Weekly"
//    case MultipleTimesWeekly = "Multiple times a week"
//    case AsNeeded = "As needed"
//}

struct Medication: Codable, Identifiable, Hashable {
    var id = UUID()
    var type: MedicationType
    var name: String
    var form: MedicationForm?
    var strength: String?
    var strengthUnit: StrengthOptions?
    var frequency: MedicationIntakeFrequency?
    var stillTaking: Bool?
    var howLongTakingFor: String? // Days
    var howLongTookFor: String? // Days
    var lengthTakingUnit: ConsumptionLength?
    var lengthTakenUnit: ConsumptionLength?
    var courseEnd: Date?
    let dateRecorded: Date
}

func stringRepMedication(med: Medication) -> String {
    switch med.type {
        case .noLongerTaking:
            return "Was previously taking \(med.name)"
        case .shortTerm:
            return "Was previously taking \(med.name)"
        case .ongoing:
            return "Currently taking \(med.name)"
    }
}
