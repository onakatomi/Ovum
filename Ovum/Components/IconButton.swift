import SwiftUI

struct IconButton: View {
    var body: some View {
        Button {
            
        } label: {
            Image(systemName: "house.fill")
                .frame(width: 52, height: 52)
                .foregroundColor(.white)
                .background(.black)
                .cornerRadius(15)
        }
    }
}
