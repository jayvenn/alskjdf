//
//  Subject.swift
//  Learn CS in AR
//
//  Created by Jayven Nhan on 4/26/18.
//  Copyright © 2018 Jayven Nhan. All rights reserved.
//

import UIKit

enum CourseSubject {
    case dataStructures, algorithms, sorting
}

struct Course {
    
    let name: String
    var description = ""
    var lessons = [Lesson]()
    
    init(courseSubject: CourseSubject) {
        switch courseSubject {
        case .dataStructures:
            name = NSLocalizedString("Data Structures", comment: "Data Structures")
            let lesson1 = Lesson(lessonName: .stack)
            let lesson2 = Lesson(lessonName: .queue)
            let lesson3 = Lesson(lessonName: .singlyLinkedList)
            let lesson4 = Lesson(lessonName: .doublyLinkedList)
            let lesson5 = Lesson(lessonName: .binaryTree)
            lessons = [lesson1, lesson2, lesson3, lesson4, lesson5]
        case .algorithms:
            name = "Algorithms"
        case .sorting:
            name = "Sorting"
        }
    }
    
    var showComingSoon: Bool {
        return lessons.count == 0 ? true : false
    }
    
}
