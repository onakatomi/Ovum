//
//  SecondaryButton.swift
//  Ovum
//
//  Created by Ollie Quarm on 13/3/2024.
//

import SwiftUI

struct SecondaryButton: View {
    let text: String
    let handler: (() -> Void)
    
    var body: some View {
        Button {
            handler()
        } label: {
            Text(text)
                .underline()
                .font(Font.subheadline.weight(.bold))
                .foregroundColor(Color(.white))
        }
    }
}

#Preview {
    SecondaryButton(text: "Terms of Use") {
        print("TODO")
    }
}
