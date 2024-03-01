//
//  Header.swift
//  Ovum
//
//  Created by Ollie Quarm on 29/2/2024.
//

import SwiftUI

struct Header: View {
    var firstLine: String
    var secondLine: String
    var colour: Color
    
    init(firstLine: String, secondLine: String, colour: Color) {
        self.firstLine = firstLine
        self.secondLine = secondLine
        self.colour = colour
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(firstLine)
            Text(secondLine)
        }
        .font(.largeTitle)
        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        .foregroundColor(colour)
    }
}

#Preview {
    Header(firstLine: "Chat with", secondLine: "Ovum", colour: Color(.black))
}
