//
//  TasksModuleBuilder.swift
//  todotest
//
//  Created by Иван Незговоров on 18.11.2024.
//


import UIKit

final class TasksModuleBuilder {
    static func build() -> UIViewController {
        let interactor = TasksInteractor()
        let router = TasksRouter()
        let view = TasksViewController()
        let presenter = TasksPresenter(interactor: interactor, view: view, router: router)
        interactor.presenter = presenter
        view.presenter = presenter
        
        return UINavigationController(rootViewController: view)
    }
    static func taskDetailsBuild(task: Task?) -> UIViewController {
        let interactor = DescriptionInteractor()
        let router = DescriptionRouter()
        let view = DescriptionViewController()
        let presenter = DescriptionPresenter(view: view, interactor: interactor, router: router, selectedTask: task)
        interactor.presenter = presenter
        view.presenter = presenter
        return view
    }
}
