//
//  CartView.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct CartView: View {
    var cart: Cart
    
    @State private var isPresented = false

    var body: some View {
        if cart.courses.isEmpty {
            Text("Your cart is empty. Let's add something")
                .foregroundStyle(.secondary)
                .navigationTitle("Cart")
        } else {
            ZStack(alignment: .bottom) {
                List {
                    ForEach(cart.courses) { course in
                        Text(course.title)
                    }
                    .onDelete { idSet in
                        cart.deleteCourse(idSet: idSet)
                    }
                }
                
                Button(action: {
                    isPresented.toggle()
                }) {
                    Label("Checkout", systemImage: "dollarsign.circle")
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.blue, in: RoundedRectangle(cornerRadius: 2))
                        .foregroundStyle(.white)
                        .contentShape(Rectangle())
                }
                .sheet(isPresented: $isPresented) {
                    cart.courses = []
                } content: {
                    CheckoutView(cart: cart)
                }

            }
            .navigationTitle("Cart")
        }
        
        
    }
}

#Preview {
    CartView(cart: Cart())
}
