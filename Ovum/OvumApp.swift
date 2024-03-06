//
//  OvumApp.swift
//  Ovum
//
//  Created by Ollie Quarm on 28/2/2024.
//

import SwiftUI

@main
struct OvumApp: App {
    @State private var viewModel = MessageViewModel() // create a model instance. initializes state in an app only once during the lifetime of the app.
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(viewModel) // supply it to ContentView using the environment(_:) modifier.
        }
    }
}
