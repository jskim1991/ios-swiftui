//
//  Grocery.swift
//  grocery-app
//
//  Created by jay on 9/10/26.
//

import Foundation
import SwiftData

@Model
final class Grocery {
    var name: String
    var desc: String
    
    /* note: init required by swift data */
    init(name: String, desc: String) {
        self.name = name
        self.desc = desc
    }
}
