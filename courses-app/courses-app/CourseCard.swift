//
//  CourseCard.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import SwiftUI

struct CourseCard: View {
    
    var course: Course
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(course.title)
                .bold()
                .font(.title2)
            
            Text(course.desc)
                .fixedSize(horizontal: false, vertical: true)
            
            GeometryReader { geometry in
                HStack {
                    
                    Circle()
                        .foregroundStyle(Color.red)
                        .frame(width: 10, height: 10)
                    Text(course.duration)
                    
                    Circle()
                        .foregroundStyle(Color.green)
                        .frame(width: 10, height: 10)
                    Text(course.category.rawValue)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    
                    Circle()
                        .foregroundStyle(Color.blue)
                        .frame(width: 10, height: 10)
                    Text(course.publishedDate.formatted(date: .abbreviated, time: .omitted))
                }
            }
            .frame(height: 20)
            .padding(.top, 10)
            .foregroundStyle(Color.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
    }
}

#Preview {
    CourseCard(course: Course.sampleData[2])
}
