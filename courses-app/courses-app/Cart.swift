//
//  Cart.swift
//  courses-app
//
//  Created by jay on 9/9/26.
//

import Observation

@Observable
class Cart {
    var courses: [Course] = []

    func addCourse(course: Course) {
        guard !contains(course: course) else { return }
        courses.append(course)
    }

    func contains(course: Course) -> Bool {
        courses.contains(where: { existing in existing.id == course.id })
    }
}
