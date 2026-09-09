//
//  CourseDetailView.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct CourseDetailView: View {
    
    var course: Course
    var cart: Cart
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .bottom) {
                Image("CoursesBannerPro")
                    .resizable()
                    .scaledToFit()
                    .blur(radius: 5)
                
                Text(course.title)
                    .bold()
                    .font(.title)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial)
            }
            
            VStack(alignment: .leading) {
                Text(course.desc)
                listItem(item: course.duration)
                listItem(item: course.category.rawValue)
                listItem(item: course.publishedDate.formatted(date: .abbreviated, time: .omitted))
            }
            .padding()
            
            Text("Related Courses")
                .bold()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Course.sampleData) { c in
                        Text(c.title)
                            .frame(width: 100, height: 100)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                cart.addCourse(course: course)
            }) {
                Label(
                    isInCart ? "Already Added to Cart" : "Add to Cart",
                    systemImage: isInCart ? "checkmark.circle.fill" : "cart"
                )
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(isInCart ? .green : .blue, in: RoundedRectangle(cornerRadius: 2))
                .foregroundStyle(.white)
                .contentShape(Rectangle())
            }
            .disabled(isInCart)
            .padding(.bottom)
        }
        .padding()
    }
    
    private var isInCart: Bool {
        cart.contains(course: course)
    }
    
    @ViewBuilder
    private func listItem(item: String) -> some View {
        HStack {
            Circle()
                .frame(width: 10, height: 10)
            
            Text(item)
        }
    }
}

#Preview {
    CourseDetailView(course: Course.sampleData[0], cart: Cart())
}
