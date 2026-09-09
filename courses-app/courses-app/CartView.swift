//
//  CartView.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct CartView: View {
    var cart: Cart

    var body: some View {
        if cart.courses.isEmpty {
            Text("Your cart is empty. Let's add something")
                .foregroundStyle(.secondary)
                .navigationTitle("Cart")
        } else {
            List(cart.courses) { course in
                Text(course.title)
            }
            .navigationTitle("Cart")
        }
        
        
    }
}

#Preview {
    CartView(cart: Cart())
}
