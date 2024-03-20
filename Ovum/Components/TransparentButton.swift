//
//  TransparentButton.swift
//  Ovum
//
//  Created by Ollie Quarm on 13/3/2024.
//

import SwiftUI

struct TransparentButton: View {
    let text: String
    let colour: Color
    let handler: (() -> Void)
    
    var body: some View {
        Button {
            handler()
        } label: {
            Text(text)
                .frame(maxWidth: .infinity)
                .foregroundColor(colour)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .inset(by: 0.5)
                        .stroke(colour, lineWidth: 1)
                )
        }
    }
}

#Preview {
    TransparentButton(text: "Sign Out", colour: Color(.blue)) {
        print("Signing Out")
    }
}
