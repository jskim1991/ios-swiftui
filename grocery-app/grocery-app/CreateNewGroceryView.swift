//
//  CreateNewGroceryView.swift
//  grocery-app
//
//  Created by jay on 9/10/26.
//

import SwiftUI
import SwiftData

struct CreateNewGroceryView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var name: String = ""
    @State private var description: String = ""
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
            TextField("Description", text: $description)
            
            Button(action: {
                guard !name.isEmpty && !description.isEmpty else {
                    return
                }
                
                let grocery = Grocery(name: name, desc: description)
                modelContext.insert(grocery)
                
                do {
                    try modelContext.save()
                    name = ""
                    description = ""
                } catch {
                    print(error.localizedDescription)
                }
            }) {
                Label("Create", systemImage: "plus")
            }
            .buttonStyle(.borderedProminent)
            
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }
}

#Preview {
    CreateNewGroceryView()
}
