//
//  ContentView.swift
//  grocery-app
//
//  Created by jay on 9/10/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Query private var groceries: [Grocery]
    
    var body: some View {
        VStack {
            List(groceries) { grocery in
                VStack(alignment: .leading) {
                    Text(grocery.name)
                        .font(.body)
                        .foregroundStyle(.primary)
                    
                    Text(grocery.desc)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            
            CreateNewGroceryView()
        }
        .navigationTitle("Groceries")
        
        
    }
}

#Preview {
    ContentView()
}
