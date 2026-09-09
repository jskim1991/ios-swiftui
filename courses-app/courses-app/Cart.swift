//
//  Cart.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import Observation
import SwiftUI

@Observable
class Cart {
    var courses: [Course] = []

    func addCourse(course: Course) {
        if contains(course: course) {
            return
        }

        courses.append(course)
    }

    func contains(course: Course) -> Bool {
        courses.contains(where: { existing in existing.id == course.id })
    }
    
    func deleteCourse(idSet: IndexSet) {
        courses.remove(atOffsets: idSet)
    }
}
