//
//  TransparentButton.swift
//  Ovum
//
//  Created by Ollie Quarm on 13/3/2024.
//

import SwiftUI

struct TransparentButton: View {
    let text: String
    let handler: (() -> Void)
    
    var body: some View {
        Button {
            handler()
        } label: {
            Text(text)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(.white))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .inset(by: 0.5)
                        .stroke(Color(.white), lineWidth: 1)
                )
        }
    }
}

#Preview {
    TransparentButton(text: "Sign Out") {
        print("Signing Out")
    }
}
