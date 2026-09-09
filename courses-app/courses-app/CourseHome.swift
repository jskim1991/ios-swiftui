//
//  CourseHome.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct CourseHome: View {
    
    var courses = Course.sampleData
    var cart = Cart()
    
    var body: some View {
        TabView {
            
        
            NavigationStack {
                List(courses) { course in
                    CourseCard(course: course)
                        .listRowSeparator(.hidden)
                        .background(
                            NavigationLink(value: course) {
                                EmptyView()
                            }
                                .opacity(0)
                        )
                }
                .listStyle(.plain)
                .navigationDestination(for: Course.self) { course in
                    CourseDetailView(course: course, cart: cart)
                }
                .navigationTitle("My Courses")
            }
            .tabItem {
              Label("Courses", systemImage: "list.bullet.circle")
            }
            
            NavigationView {
                CartView(cart: cart)
            }
            .tabItem {
                Label("Cart", systemImage: "cart.circle")
            }
        }
    }
}

#Preview {
    CourseHome()
}
