//
//  ContactPreviewModifier.swift
//  contact-list
//
//  Created by jay on 9/10/26.
//

import Foundation
import SwiftData
import SwiftUI

struct ContactPreviewModifier: PreviewModifier {
    typealias Context = ModelContainer
    
    static func makeSharedContext() async throws -> ModelContainer {
        return Contact.preview
    }
    
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
}
