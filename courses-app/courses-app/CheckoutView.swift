//
//  CheckoutView.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct CheckoutView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var cart: Cart
    
    @State private var selectedIndex = 0
    let paymentTypes: [String] = ["Credit Card", "Apple Pay"]
    @State private var completePayment = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Cart") {
                    List(cart.courses) { course in
                        HStack {
                            Text(course.title)
                            Spacer()
                            Text(course.price.formattedCurrency())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Total") {
                    HStack {
                        Text("Total amount")
                        Spacer()
                        Text(cart.courses.reduce(0, { partialResult, course in
                            let result = partialResult + course.price
                            return result
                        }).formattedCurrency())
                    }
                }
                
                Section("Payment") {
                    Picker("Payment methods", selection: $selectedIndex) {
                        ForEach(paymentTypes.indices, id: \.self) { i in
                            Text(paymentTypes[i])
                                .tag(i)
                            
                        }
                    }
                }
                
                Section("Pay") {
                    Button(action: {
                        completePayment.toggle()
                    }) {
                        Label("Pay with \(paymentTypes[selectedIndex])", systemImage: "dollarsign.square")
                    }
                    .alert("Thank you!", isPresented: $completePayment) {
                        Button("Ok", role: .cancel) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } message: {
                        Text("Your \(paymentTypes[selectedIndex]) payment has been received")
                    }
                }
            }
            .navigationTitle("Checkout")
        }
    }
}

#Preview {
    CheckoutView(cart: Cart())
}
