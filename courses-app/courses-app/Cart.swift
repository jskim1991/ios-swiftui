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
        courses.append(course)
    }
}
