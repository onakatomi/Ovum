import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        // 1
        Button(action: {

            // 2
            configuration.isOn.toggle()

        }, label: {
            HStack(alignment: .top) {
                // 3
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(Color(red: 0.98, green: 0.96, blue: 0.92))
                configuration.label
            }
        })
    }
}

extension ToggleStyle where Self == iOSCheckboxToggleStyle {
 
    static var checkmark: iOSCheckboxToggleStyle { iOSCheckboxToggleStyle() }
}
