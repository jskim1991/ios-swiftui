//
//  Contact.swift
//  contact-list
//
//  Created by jay on 9/10/26.
//

import Foundation
import SwiftData

@Model
final class Contact {
    var firstName: String
    var lastName: String
    
    init(firstName: String = "", lastName: String = "") {
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension Contact {
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Contact.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        container.mainContext.insert(Contact(firstName: "John", lastName: "Doe"))
        container.mainContext.insert(Contact(firstName: "Jane", lastName: "Doe"))
        container.mainContext.insert(Contact(firstName: "Jay", lastName: "Doe"))
        container.mainContext.insert(Contact(firstName: "Jake", lastName: "Doe"))
        
        return container
    }
}
