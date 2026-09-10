//
//  grocery_appApp.swift
//  grocery-app
//
//  Created by jay on 9/10/26.
//

import SwiftUI
import SwiftData

@main
struct grocery_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Grocery.self], inMemory: false)
        
    }
}
