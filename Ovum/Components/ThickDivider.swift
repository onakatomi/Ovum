import SwiftUI

struct ThickDivider: View {
    let color: Color
    let width: CGFloat
    let padding: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
            .padding(.vertical, padding)
    }
}
