//
//  DescriptionInteractorProtocol.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

protocol DescriptionInteractorProtocol: AnyObject {
    func createTask(title: String, description: String)
    func updateTask(task: Task)
    func deleteTask(task: Task)
}

final class DescriptionInteractor: DescriptionInteractorProtocol{
    
    var presenter: DescriptionPresenterProtocol?
    
    func createTask(title: String, description: String) {
        CoreDataStack.shared.createTask(title: title, description: description)
    }
    
    func updateTask(task: Task) {
        CoreDataStack.shared.editTask(by: String(task.id), title: task.title, descriptionText: task.description, date: task.date, isCompleted: task.isCompleted) { _ in }
    }
    
    func deleteTask(task: Task) {
        CoreDataStack.shared.deleteTask(task: task) { _ in }
    }
}
