//
//  DescriptionPresenterProtocol.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//

import UIKit

protocol DescriptionPresenterProtocol: AnyObject {
    func loadTask()
    func backToView(title: String?, description: String?)
}

final class DescriptionPresenter: DescriptionPresenterProtocol {
    
    weak var view: DescriptionViewProtocol?
    private let interactor: DescriptionInteractorProtocol
    private let router: DescriptionRouterProtocol
    
    var selectedTask: Task?
    
    init(view: DescriptionViewProtocol, interactor: DescriptionInteractorProtocol, router: DescriptionRouterProtocol, selectedTask: Task?) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.selectedTask = selectedTask
    }
    
    func loadTask() {
        guard let task = selectedTask else { return }
        let date = HelperFunc.convertToString(task.date)
        view?.updateTaskDetails(title: task.title, date: date, description: task.description)
    }
    func saveOrUpdateTask(title: String?, description: String?) {
        if description == "Введите описание" && title!.isEmpty == true {
            return
        }
        if title!.isEmpty && description!.isEmpty {
            if let task = selectedTask {
                interactor.deleteTask(task: task)
            }
            return
        }
        selectedTask?.title = title!
        selectedTask?.description = description!
        
        if let task = selectedTask {
            interactor.updateTask(task: task)
        } else {
            if description == "Введите описание" {
                interactor.createTask(title: title!, description: "")
            } else {
                interactor.createTask(title: title!, description: description!)
            }
           
        }
    }
    func backToView(title: String?, description: String?) {
        saveOrUpdateTask(title: title, description: description)
    }
}
