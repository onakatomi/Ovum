import SwiftUI

struct MedicationFormView: View {
    @EnvironmentObject var viewModel: MessageViewModel
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject var router: Router
    @Environment(\.dismiss) var dismiss
    
    let medicationFormType: MedicationType
    @State private var medicationObject: Medication = Medication(type: .ongoing, name: "", dateRecorded: Date.now)
    var isEditing: Bool = false
    @FocusState var focusField: Bool
    
    init(medicationFormType: MedicationType, medicationObj: Medication?) {
        self.medicationFormType = medicationFormType
        if (medicationObj != nil) {
            _medicationObject = State(initialValue: medicationObj!)
            isEditing = true
        } else {
            _medicationObject = State(initialValue: Medication(type: medicationFormType, name: "", dateRecorded: Date.now))
        }
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
                    Button {
                        withAnimation {
                            router.navigateWithinMedication(to: .menu)
                        }
                    } label: {
                        Image("menu_brown")
                    }
                    .navigationBarBackButtonHidden()
                }
                .padding(.bottom, 18)
                Divider()
                    .background(AppColours.maroon)
                    .padding(.bottom, 0)
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Medication name")
                                .font(Font.custom(AppFonts.haasGrot, size: 16))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .kerning(0.32)
                                .foregroundColor(AppColours.buttonBrown)
                            InputView(text: $medicationObject.name, title: "Add medication name", placeholder: "Add medication name", hasBorder: true, fieldIsFocused: $focusField)
                        }
                        
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Form")
                                .font(Font.custom(AppFonts.haasGrot, size: 16))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .kerning(0.32)
                                .foregroundColor(AppColours.buttonBrown)
                            Picker("Form", selection: $medicationObject.form) {
                                Text(.init("*Select form from below*")).tag(nil as MedicationForm?)
                                ForEach(MedicationForm.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category as MedicationForm?)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white)
                                    .stroke(AppColours.darkBrown, lineWidth: 1)
                            )
                            
                        }
                        
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Strength")
                                .font(Font.custom(AppFonts.haasGrot, size: 16))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .kerning(0.32)
                                .foregroundColor(AppColours.buttonBrown)
                            HStack {
                                InputView(text: ($medicationObject.strength.toUnwrapped(defaultValue: "")), title: "Strength", placeholder: "Add number", hasBorder: true, fieldIsFocused: $focusField)
                                //                    Spacer()
                                Picker("Strength Units", selection: $medicationObject.strengthUnit) {
                                    Text(.init("*Select unit*")).tag(nil as StrengthOptions?)
                                    ForEach(StrengthOptions.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(category as StrengthOptions?)
                                    }
                                }
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white)
                                        .stroke(AppColours.darkBrown, lineWidth: 1)
                                )
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Frequency")
                                .font(Font.custom(AppFonts.haasGrot, size: 16))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .kerning(0.32)
                                .foregroundColor(AppColours.buttonBrown)
                            Picker(selection: $medicationObject.frequency, label: Text("Select a freq")) {
                                Text(.init("*Select frequency from below*")).tag(nil as MedicationIntakeFrequency?)
                                ForEach(MedicationIntakeFrequency.allCases, id: \.self) { category in
                                    Text(category.rawValue).tag(category as MedicationIntakeFrequency?)
                                }
                            }
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white)
                                    .stroke(AppColours.darkBrown, lineWidth: 1)
                            )
                        }
                        
                        if (isEditing && medicationObject.type == .ongoing) {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Are you still taking this medication?")
                                    .font(Font.custom(AppFonts.haasGrot, size: 16))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .kerning(0.32)
                                    .foregroundColor(AppColours.buttonBrown)
                                HStack(spacing: 10) {
                                    TransparentButton(text: "Yes", colour: AppColours.buttonBrown) {
                                        medicationObject.stillTaking = true
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill((medicationObject.stillTaking == nil || !medicationObject.stillTaking!) ? Color.clear : AppColours.indigo)
                                    )
                                    TransparentButton(text: "No", colour: AppColours.buttonBrown) {
                                        medicationObject.stillTaking = false
                                    }
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill((medicationObject.stillTaking == nil || medicationObject.stillTaking!) ? Color.clear : AppColours.indigo)
                                    )
                                }
                            }
                        }
                        
                        if (medicationFormType == .shortTerm) {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("How long are you taking it for?")
                                    .font(Font.custom(AppFonts.haasGrot, size: 16))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .kerning(0.32)
                                    .foregroundColor(AppColours.buttonBrown)
                                HStack {
                                    InputView(text: $medicationObject.howLongTakingFor.toUnwrapped(defaultValue: ""), title: "How long are you taking it for?", placeholder: "Add number", hasBorder: true, fieldIsFocused: $focusField)
                                    Picker("How long are you taking it for?", selection: $medicationObject.lengthTakingUnit) {
                                        Text(.init("*Select length from below*")).tag(nil as ConsumptionLength?)
                                        ForEach(ConsumptionLength.allCases, id: \.self) { category in
                                            Text(category.rawValue).tag(category as ConsumptionLength?)
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(.white)
                                            .stroke(AppColours.darkBrown, lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        if (medicationFormType == .noLongerTaking) {
                            VStack(alignment: .leading, spacing: 14) {
                                Text("How long did you take it for?")
                                    .font(Font.custom(AppFonts.haasGrot, size: 16))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .kerning(0.32)
                                    .foregroundColor(AppColours.buttonBrown)
                                HStack {
                                    InputView(text: $medicationObject.howLongTookFor.toUnwrapped(defaultValue: ""), title: "How long did you take it for?", placeholder: "Add number", hasBorder: true, fieldIsFocused: $focusField)
                                    Picker("How long are you taking it for?", selection: $medicationObject.lengthTakenUnit) {
                                        ForEach(ConsumptionLength.allCases, id: \.self) { category in
                                            Text(.init("*Select length from below*")).tag(nil as ConsumptionLength?)
                                            Text(category.rawValue).tag(category as ConsumptionLength?)
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(.white)
                                            .stroke(AppColours.darkBrown, lineWidth: 1)
                                    )
                                }
                            }
                        }
                        
                        if (medicationFormType == .shortTerm || medicationFormType == .noLongerTaking) {
                            VStack(alignment: .leading, spacing: 14) {
                                Text(medicationFormType == .shortTerm ? "When does the course end?" : "When did the course end?")
                                    .font(Font.custom(AppFonts.haasGrot, size: 16))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .kerning(0.32)
                                    .foregroundColor(AppColours.buttonBrown)
                                DatePicker("Select a date:",
                                           selection: $medicationObject.courseEnd.toUnwrapped(defaultValue: Date.now),
                                           displayedComponents: [.date]
                                           
                                )
                                .datePickerStyle(.compact)
                            }
                        }
                        //                    Spacer()
                        Button {
                            if (medicationFormType == .ongoing) {
                                // If we're editing a medication object
                                if (isEditing) {
                                    if let index = viewModel.currentMedication.firstIndex(where: { $0.id == medicationObject.id }) {
                                        if (medicationObject.stillTaking != nil && !medicationObject.stillTaking!) {
                                            medicationObject.type = .noLongerTaking
                                            viewModel.currentMedication.remove(at: index)
                                            viewModel.pastMedication.append(medicationObject)
                                        } else {
                                            viewModel.currentMedication[index] = medicationObject
                                        }
                                    }
                                } else {
                                    viewModel.currentMedication.append(medicationObject)
                                }
                            } else {
                                if (isEditing) {
                                    if let index = viewModel.pastMedication.firstIndex(where: { $0.id == medicationObject.id }) {
                                        viewModel.pastMedication[index] = medicationObject
                                    }
                                } else {
                                    viewModel.pastMedication.append(medicationObject)
                                }
                            }
                            
                            Task {
                                viewModel.isSavingMedication = true
                                await viewModel.addMedicationToCloud(medication: medicationObject, userId: authModel.currentUser!.id)
                                viewModel.isSavingMedication = false
                                router.navigateToRoot(within: .medication)
                            }
                        } label: {
                            Text("Done")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .inset(by: 0.5)
                                        .fill(
                                            AppColours.indigo)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 1) // accomodate border
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .background {
                AppColours.brown
                    .ignoresSafeArea()
            }
            .navigationBarBackButtonHidden(true)
            .opacity(viewModel.isSavingMedication ? 0.5 : 1.0)
            
            // Top layer of ZStack
            if (viewModel.isSavingMedication) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppColours.maroon))
            }
        }
    }
    
    func returnDays(numberAsString: String?, unit: ConsumptionLength) -> Int? {
        if numberAsString == nil {
            return nil
        }
        
        switch (unit) {
            case .days:
                return Int(numberAsString!)
            case .weeks:
                return Int(numberAsString!)!*7 // Must not be nil.
            case .months:
                return Int(numberAsString!)!*30
            case .years:
                return Int(numberAsString!)!*365
        }
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

#Preview {
    MedicationFormView(medicationFormType: .noLongerTaking, medicationObj: Medication(type: .ongoing, name: "", dateRecorded: Date.now))
        .environmentObject(Router())
        .environmentObject(MessageViewModel(userId: "1", authViewModelPassedIn: AuthViewModel()))
}
