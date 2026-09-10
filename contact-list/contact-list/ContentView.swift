//
//  ContentView.swift
//  contact-list
//
//  Created by jay on 9/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var contacts: [Contact]
    
    var body: some View {
        NavigationStack {
            List(contacts) { c in
                HStack(spacing: 5) {
                    Text(c.firstName)
                    Text(c.lastName)
                }
            }
        }
    }
}

#Preview(traits: .modifier(ContactPreviewModifier())) {
    ContentView()
        
}
