//
//  Task.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//


import Foundation
import CoreData
import UIKit

struct Task: Codable {
    var id: Int
    var title: String
    var description: String
    var date: Date
    var isCompleted: Bool
}

struct Todo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct Response: Codable {
    let todos: [Todo]
    let total: Int
    let skip: Int
    let limit: Int
}
