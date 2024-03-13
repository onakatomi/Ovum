import SwiftUI

struct TypingIndicator: View {
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var count: Int = 0
    
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .offset(y: count == 1 ? -5 : 0)            
            Circle()
                .offset(y: count == 2 ? -5 : 0)
            Circle()
                .offset(y: count == 3 ? -5 : 0)
        }
        .padding()
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .foregroundColor(Color(.lightGray))
        .onReceive(timer, perform: { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                count = count == 3 ? 0 : count + 1
            }
        })
    }
}

struct TypingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        TypingIndicator()
    }
}
